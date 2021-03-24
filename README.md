![inspec-test](https://github.com/devops-adeel/terraform-vault-secrets-aws/actions/workflows/terraform-apply.yml/badge.svg)

# Terraform Vault Secrets AWS
## Overview
This terraform module mounts an AWS Secrets Engine in Vault.  It also creates an
ACL templated policy bound to an Identity Group, expecting any auth-role's entity
to be added as members.

This module does not create the dynamic AWS roles themselves, rather this is a
repeatable in mounting AWS secrets engine with an associated, opinionated ACL
policies.

The common use-case for a repeatable module is mounting secrets engine per
namespace (Enterprise Feature) in an opinionated, standardised fashion.

This module is intended to prove the standardised provisioning of Vault resources
per namespace with a decentralised approach.


## Requirements

This module requires that you have AWS credentials with the necessary
[IAM](https://www.vaultproject.io/docs/secrets/aws#example-iam-policy-for-vault)
policy for Vault to manage dynamic IAM users.

Credentials will be in the following environment variables:
AWS_ACCESS_KEY AWS_SECRET_KEY, AWS_REGION
https://www.vaultproject.io/api-docs/secret/aws#configure-root-iam-credentials

It is best to create an "trusted" Lamba function which will trigger upon the
vault-audit log showing a successful request of aws-secrets-backend
the function is to send a POST the following endpoint: `/aws/config/rotate-root`

```
 $ curl \
    --header "X-Vault-Token: ..." \
    --request POST \
    http://127.0.0.1:8200/v1/aws/config/rotate-root
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
Usage:

```hcl

module "vault_aws_secrets" {
  source      = "git::https://github.com/devops-adeel/terraform-vault-secrets-aws.git?ref=v0.1.0"
  entity_ids = [module.vault_approle.entity_id]
}
```

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_vault"></a> [vault](#provider\_vault) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [vault_aws_secret_backend.default](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/aws_secret_backend) | resource |
| [vault_identity_entity.default](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/identity_entity) | resource |
| [vault_identity_group.default](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/identity_group) | resource |
| [vault_identity_group_policies.default](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/identity_group_policies) | resource |
| [vault_policy.default](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/policy) | resource |
| [vault_identity_entity.default](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/identity_entity) | data source |
| [vault_policy_document.default](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_entity_ids"></a> [entity\_ids](#input\_entity\_ids) | List of Vault Identity Member IDs | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_backend_path"></a> [backend\_path](#output\_backend\_path) | Secrets Backend Path as output |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
