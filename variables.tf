variable "resource_prefix" {
  description = "Prefix to be used for naming new resources"
  type        = string
  default     = "cloudquery"
}

variable "aws_account_id" {
  description = "Uptycs AWS account ID"
  type        = string
}

variable "external_id" {
  description = "Role external ID provided by Uptycs"
  type        = string
}

variable "cloud_logs_enabled" {
  type        = bool
  description = "Required Whether customer wants attach cloudtrail and VPC buckets for logging."
  default     = false
}

variable "vpc_flowlogs_bucket_name" {
  type        = string
  description = "S3 bucket where VPC flow logs are saved. Required if cloud_logs_enabled is set to 'true'"
  default     = ""
}

variable "cloudtrail_s3_bucket_name" {
  type        = string
  description = "S3 bucket where CloudTrail is saved. Requried if cloud_logs_enabled is set to 'true'"
  default     = ""
}

variable "tags" {
  description = "Tags to apply to the resources created by this module"
  type        = map(string)
  default = {}
}