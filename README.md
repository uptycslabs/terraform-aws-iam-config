# Terraform AWS IAM role module

- This module allows you to create AWS IAM role with required policies and return role ARN which can be used for Uptycs service integration for each account in an organization.
- This terraform module will create a IAM Role in each account with the following policies attached:
  - policy/job-function/ViewOnlyAccess
  - policy/SecurityAudit
  - Custom read only policy access for required resources

## Create a <file.tf> file, paste below codes and modify as needed.

```
# fetch all the accounts in an organization
data "aws_organizations_organization" "listaccounts" {}

# Creating provider for each account
resource "local_file" "providers" {
 filename = "<directory>/providers.tf"
 content = <<EOT
  %{ for ac in data.aws_organizations_organization.listaccounts.non_master_accounts ~}
  %{ if ac.status == "ACTIVE" ~}

provider "aws" {
  assume_role {
    // Assume the organization access role
    role_arn = "arn:aws:iam::${ac.id}:role/OrganizationAccountAccessRole"
  }
  alias = "<prefix>-${ac.id}"
}
%{ endif ~}
%{ endfor ~}
EOT
}

# creating module for each account
resource "local_file" "modules" {
  filename = "<directory>/modules.tf"
  content = <<EOT
  %{ for ac in data.aws_organizations_organization.listaccounts.non_master_accounts ~}
  %{ if ac.status == "ACTIVE" ~}

module "iam-config-${ac.id}" {
  source             = "/home/llukalapu/terraformorg/terraform-aws-iam-config"
  providers = {
    aws = aws.<prefix>-${ac.id}
  }
  child_account_id = "${ac.id}"
  child_account_name = "${ac.name}"

  # Copy the AWS Account ID from Uptycs' UI
  # Uptycs' UI : "Cloud"->"AWS"->"Integrations"->"ACCOUNT INTEGRATION"
  aws_account_id = "<uptycs-accountid>"
  
  # uuid will be generated based on the prefix you give
  external_id = uuidv5("oid", "uptycs-${ac.id}")

  tags = {
    Service = "cloudquery"
  }
}
%{ endif ~}
%{ endfor ~}
EOT

}

resource "local_file" "outputs" {
  filename = "<directory>/outputs.tf"
  content = <<EOT
  %{ for ac in data.aws_organizations_organization.listaccounts.non_master_accounts ~}
  %{ if ac.status == "ACTIVE" ~}

output "aws-iam-role-arn-${ac.id}" {
  value = module.iam-config-${ac.id}.aws_iam_role_arn
}
%{ endif ~}
%{ endfor ~}
EOT
}

```

## Inputs

| Name                      | Description                                                                                            | Type     | Default      |
| ------------------------- | ------------------------------------------------------------------------------------------------------ | -------- | ------------ |
| resource_prefix           | Prefix to be used for naming new resources                                                             | `string` | `cloudquery` |
| aws_account_id            | Uptycs AWS account ID                                                                                  | `string` | `""`         |                                                              | `string` | `""`         |
| tags                      | Tags to apply to the resources created by this module                                                  | `map`    | empty        |

## Outputs

| Name             | Description      |
| ---------------- | ---------------- |
| aws_iam_role_arn | AWS IAM role ARN and externalId|

## 2. Set Region before execute terraform

```sh
export AWS_DEFAULT_REGION="< pass region >"
```

## 3. Execute Terraform script

```sh
$ terraform init
$ terraform plan
$ terraform apply
```
## 4. After running above commands three files will be created in the the given directory. Go to that directory and again follow the step3.
After step 4, roles and policies will be created in each account and will get the output of role arn and external id of each account.
## Notes:-

- The user should have `Administrators` role permission to create resources.
- If the user has multiple aws account profiles then set profile before execute terraform.
  ```sh
    export AWS_PROFILE="< profile name >"
  ```
