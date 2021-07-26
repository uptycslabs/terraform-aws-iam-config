variable "resource_prefix" {
  description = "Pass prefix to identify created resources."
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

variable "vpc_log_bucket_arn" {
  type        = string
  description = "The VPC log bucket arn if cloud_logs_enabled is set true."
  default     = ""
}

variable "cloudtrail_log_bucket_arn" {
  type        = string
  description = "The cloudtrail log bucket arn if cloud_logs_enabled is set true."
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




