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
  # Copy the AWS Account ID from Uptycs' UI
  # Uptycs' UI : "Cloud"->"AWS"->"Integrations"->"ACCOUNT INTEGRATION"
  aws_account_id = "<Uptycs-AWS-ACCOUNT-ID>"
  # Copy the actual values from Uptycs' AWS Integration screen
  # You can generate your own UUID. Make sure Uptycs' UI is updated with same value
  external_id    = "<UUID4>"

  # CloudTrail source: S3 Bucket or Kinesis stream?
  # Set either `cloudtrail_s3_bucket_name` or `kinesis_stream_name` to allow Uptycs to ingest CloudTrail events
  # Provide the S3 bucket name which contains the CloudTrail data
  cloudtrail_s3_bucket_name = ""
  # Name of the Kinesis stream configured to stream CloudTrail data
  kinesis_stream_name = ""

  # Name of the S3 bucket that contains the VPC flow logs
  vpc_flowlogs_bucket_name = ""

  tags = {
    Service     = "cloudquery"
  }
}

output "aws-iam-role-arn" {
  value = module.iam-config.aws_iam_role_arn
}
```

## Inputs

| Name                      | Description                                                                                            | Type     | Required | Default      |
| ------------------------- | ------------------------------------------------------------------------------------------------------ | -------- | -------- | ------------ |
| resource_prefix           | Prefix to be used for naming new resources                                                             | `string` |          | `cloudquery` |
| aws_account_id            | Uptycs AWS account ID                                                                                  | `string` | Yes      |              |
| external_id               | Role external ID provided by Uptycs                                                                    | `string` | Yes      |              |
| vpc_flowlogs_bucket_name  | Name of the S3 bucket that contains the VPC flow logs                                                  | `string` |          | Blank        |
| cloudtrail_s3_bucket_name | Name of the S3 bucket which contains the CloudTrail data                                               | `string` |          | Blank        |
| kinesis_stream_name       | Name of the Kinesis stream configured to stream CloudTrail data                                        | `string` |          | Blank        |
| tags                      | Tags to apply to the resources created by this module                                                  | `map`    |          | `{}`         |

## Outputs

| Name             | Description      |
| ---------------- | ---------------- |
| aws_iam_role_arn | AWS IAM role ARN |

## 2. Set Region before execute terraform

```sh
export AWS_DEFAULT_REGION="<region-code>"
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
- In file.tf file, specify CloudTrail S3 bucket name or Kinesis stream name. Kinesis stream based approach provides faster CloudTrail data ingestion
