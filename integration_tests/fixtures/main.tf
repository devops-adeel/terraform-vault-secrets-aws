locals {
  application_name = "terraform-modules-development-aws"
  env              = "dev"
  service          = "adeel"
}

module "default" {
  source     = "./module"
  entity_ids = [module.vault_approle.entity_id]
}

data "vault_auth_backend" "default" {
  path = "approle"
}

module "vault_approle" {
  source           = "git::https://github.com/devops-adeel/terraform-vault-approle.git?ref=v0.6.1"
  application_name = local.application_name
  env              = local.env
  service          = local.service
  mount_accessor   = data.vault_auth_backend.default.accessor
}

resource "vault_aws_secret_backend_role" "default" {
  backend         = module.default.backend_path
  name            = format("%s-%s", local.env, local.service)
  credential_type = "iam_user"
  policy_document = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "iam:*",
      "Resource": "*"
    }
  ]
}
EOT
}

##
## To validate Vault ACL policy, the code below shall be executed.
##

resource "vault_approle_auth_backend_login" "default" {
  backend   = module.vault_approle.backend_path
  role_id   = module.vault_approle.approle_id
  secret_id = module.vault_approle.approle_secret
}

provider "vault" {
  alias     = "default"
  token     = vault_approle_auth_backend_login.default.client_token
  namespace = "admin/terraform-vault-secrets-aws"
}

data "vault_aws_access_credentials" "creds" {
  backend = module.default.backend_path
  role    = vault_aws_secret_backend_role.default.name
}

provider "aws" {
  access_key = data.vault_aws_access_credentials.default.access_key
  secret_key = data.vault_aws_access_credentials.default.secret_key
}

resource "aws_s3_bucket" "default" {
  bucket = local.application_name
  acl    = "private"
}
