# Terraform AWS IAM role module

- This module allows you to create AWS IAM role with required policies and return role ARN which can be used for Uptycs service integration.
- This terraform module will create a IAM Role with the following policies attached:
  - policy/job-function/ViewOnlyAccess
  - policy/SecurityAudit
  - Custom read only policy access for required resources

## Create a <file.tf> file, paste below codes and modify as needed.

```
module "iam-config" {
  source          = "github.com/uptycslabs/terraform-aws-iam-config"
  resource_prefix = "cloudquery"

  # These two values are provided by Uptycs
  aws_account_id = "1234567890"
  external_id    = "f09cd4ae-76f1-4373-88da-de721312803d"

  # Choose one option between cloudtrail bucket and kinesis stream for cloud logs

  # Pass bucket name if customer wants to attach bucket for cloudlogs
  cloudtrail_s3_bucket_name = ""

  # Pass kinesis stream name if customer wants to attach kinesis stream for cloudlogs
  kinesis_stream_name = ""

  # Pass bucket name if customer wants to attach bucket for vpc flow logs
  vpc_flowlogs_bucket_name = ""

  tags = {
    Environment = "dev"
    Service     = "cloudquery"
  }
}

output "aws-iam-role-arn" {
  value = module.iam-config.aws_iam_role_arn
}
```

## Inputs

| Name                      | Description                                                                                            | Type     | Default      |
| ------------------------- | ------------------------------------------------------------------------------------------------------ | -------- | ------------ |
| resource_prefix           | Prefix to be used for naming new resources                                                             | `string` | `cloudquery` |
| aws_account_id            | Uptycs AWS account ID                                                                                  | `string` | `""`         |
| external_id               | Role external ID provided by Uptycs                                                                    | `string` | `""`         |
| vpc_flowlogs_bucket_name  | S3 bucket where VPC flow logs are saved. Required, if you want to use S3 bucket for vpc flow logs               | `string` | `""`         |
| cloudtrail_s3_bucket_name | S3 bucket where CloudTrail is saved. Requried, if you want to use S3 bucket for cloud logs                  | `string` | `""`         |
| kinesis_stream_name       | Kinesis stream where CloudTrail logs are streamed. Required, if you want to use kinesis stream for cloud logs | `string` | `""`         |
| tags                      | Tags to apply to the resources created by this module                                                  | `map`    | empty        |

## Outputs

| Name             | Description      |
| ---------------- | ---------------- |
| aws_iam_role_arn | AWS IAM role ARN |

## 2. Set Region before execute terraform

```sh
export AWS_DEFAULT_REGION="< pass region >"
```

## 3. Execute Terraform script to get role arn

```sh
$ terraform init
$ terraform plan
$ terraform apply
```

## Notes:-

- The user should have `Administrators` role permission to create resources.
- If the user has multiple aws account profiles then set profile before execute terraform.
  ```sh
    export AWS_PROFILE="< profile name >"
  ```
 - In file.tf file, choose one option between cloudtrail bucket and kinesis stream for cloudlog monitoring . Give priority to kinesis stream
