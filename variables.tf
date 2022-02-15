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
  description = "Required. Whether customer wants to attach cloudtrail or VPC buckets or kinesis data stream for logging."
  default     = false
}

variable "vpc_flowlogs_bucket_name" {
  type        = string
  description = "S3 bucket where VPC flow logs are saved. Required. Whether customer wants to attach VPC flow log bucket for logging."
  default     = ""
}

variable "cloudtrail_s3_bucket_name" {
  type        = string
  description = "S3 bucket where CloudTrail is saved. Required. Whether customer wants to attach cloudtrail bucket for logging."
  default     = ""
}

variable "kinesis_stream_name" {
  description = "Kinesis stream name for cloudtrail logs. Required. Whether customer wants to attach kinesis stream for logging."
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags to apply to the resources created by this module"
  type        = map(string)
  default     = {}
}
