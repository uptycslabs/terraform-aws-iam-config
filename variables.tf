variable "resource_prefix" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = "CustomerCloudQuery"
}

variable "aws_account_id" {
  description = "Aws account id of Uptycs"
  type        = string
}

variable "external_id" {
  description = "ExternalId to be used for API authentication."
  type        = string
}

variable "cloud_logs_enabled" {
  type        = bool
  description = "Required Whether customer wants attach cloudtrail and VPC buckets for logging."
  default     = false
}

variable "vpc_log_bucket_name" {
  type        = string
  description = "Bucket to store vpc flow logs, pass if cloud_logs_enabled is set true."
  default     = ""
}

variable "cloudtrail_log_bucket_name" {
  type        = string
  description = "Bucket to store cloudtrail logs, pass if cloud_logs_enabled is set true."
  default     = ""
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default = {
    Environment = "Dev"
    Service     = "CloudQuery"
  }
}




