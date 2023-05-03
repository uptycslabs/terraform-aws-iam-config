variable "resource_region" {
  type = string
}

variable "bucket_name" {
  type = string
}

provider "aws" {
  region = var.resource_region
}

data "aws_s3_bucket" "bucket_details" {
  count =  var.bucket_name != "" ? 1:0
  bucket = var.bucket_name
}

output "bucket_arn" {
  value = var.bucket_name != "" ? data.aws_s3_bucket.bucket_details[0].arn : null
}
