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

This module requires that you have AWS credentials with the necessary [IAM]
(https://www.vaultproject.io/docs/secrets/aws#example-iam-policy-for-vault)
policy for Vault to manage dynamic IAM users.

## Providers

| Name    | Version   |
| ------  | --------- |
| `vault` | n/a       |

## Inputs

| Name         | Description                       | Type        | Default   | Required   |
| ------       | -------------                     | ------      | --------- | :--------: |
| `entity_ids` | List of Vault Identity Member IDs | `list(any)` | `[]`      | no         |

## Outputs

| Name           | Description                    |
| ------         | -------------                  |
| `backend_path` | Secrets Backend Path as output |
