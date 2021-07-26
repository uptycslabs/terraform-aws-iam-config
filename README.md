# Terraform AWS IAM role module

* This module allows you to create AWS IAM role with required policies and return role ARN which can be used for service integration.
* This terraform module will create below resources:-
* It will attach below policies to role :-
  * policy/job-function/ViewOnlyAccess
  * policy/SecurityAudit
  * Custom read only policy access for required resources.


# Requirements

## 1. Install terraform

## 2. User & IAM 

- The user should have Administrators access to create resource .

## 3. Get authentication

### Process 1 :-

```
 - Install awscli
 - Configure aws add below ~/.aws/credentials or use aws configure and pass credentials .
   
   [profile user]
   aws_access_key_id = < adminuser access key ID >
   aws_secret_access_key = < adminuser secret access key >
   region = < aws-region >

```

### Process 2 :-

```
 - Install AWS Google authenticator CLI:
   pip3 install aws-google-auth
   
 - Create AWS profiles in $HOME/.aws/config by using below set of lines and modify required values.
 
    [profile dev-account]
    region = < aws-region >
    google_config.ask_role = False
    google_config.keyring = True
    google_config.google_idp_id = *****
    google_config.google_sp_id = *****
    google_config.role_arn = arn:aws:iam::*******:role/Administrators
    google_config.duration = 14400
    google_config.u2f_disabled = False
    google_config.google_username = ****@xyz.com
    google_config.bg_response = None

 - Activate profile  
   aws-google-auth -p dev-account -k
   
 - set profile and region  
   export AWS_PROFILE="dev-account"
   export AWS_DEFAULT_REGION="us-east-1"

```

# Usage

## 1. Create a <file.tf> file, paste below codes and modify as needed. 

```
module "iam-config" {
  source = "github.com/uptycslabs/terraform-aws-iam-config"
    
  resource_prefix = "UptycsCloudQuery"
  aws_account_id  = "1234567890"
  external_id     = "f09cd4ae-76f1-4373-88da-de721312803d"
  cloud_logs_enabled = false

  # Pass bucket names if cloud_logs_enabled = true
  vpc_log_bucket_name = ""
  cloudtrail_log_bucket_name = ""

  tags = {
    Environment = "Dev"
    Service     = "CloudQuery"
  }
}



output "aws-iam-role-arn" {
  value = module.iam-config.aws_iam_role_arn
}

output "external_id" {
  description = "Passed UUID as external id for access config."
  value = var.external_id
}

```

## Inputs

| Name                      | Description                                                                                                        | Type          | Default          |
| ------------------------- | ------------------------------------------------------------------------------------------------------------------ | ------------- | ---------------- |
| resource_prefix           | Pass value to identify resources customer & service. Ex :- "UptycsCloudQuery"                                      | `string`      | `CustomerCloudQuery`|
| aws_account_id            | AWS account id where resources need to created.                                                                    | `string`      | `""`             |
| external_id               | ExternalId to be used for API authentication.                                                                      | `string`      | `""`             |
| cloud_logs_enabled        | This is set true or false i.e. whether you wants to use log buckets or not .                                       | `bool`        | `false`          |
| vpc_log_bucket_name       | The VPC Flow Log bucket name .                                                                                     | `string`      | `""`             |
| cloudtrail_log_bucket_name| The Cloudtrail Log bucket name .                                                                                   | `string`      | `""`             |
| tags                      | Pass tags to identify resources .                                                                                  | `map`         | `""`             |


## Outputs

| Name                    | Description                                  |
| ----------------------- | -------------------------------------------- |
| external_id             | It will return passed UUID as external id for access config        |
| aws_iam_role_arn        | It will return aws IAM role arn for access config              |


## 2. Execute Terraform script to get role arn
```
$ terraform init
$ terraform plan
$ terraform apply
```


