variable "resource_prefix" {
  description = "Pass prefix to identify created resources."
  type        = string
  default     = "cloudquery"
}

variable "aws_account_id" {
  description = "Aws account id of Uptycs"
  type        = string
}

variable "external_id" {
  description = "ExternalId to be used for API authentication."
  type        = string
}

variable "vpc_log_bucket_arn" {
  type        = string
  description = "The VPC log bucket arn (if the customer specify the name of vpc flow log bucket)"
  default     = ""
}

variable "cloudtrail_log_bucket_arn" {
  type        = string
  description = "The cloudtrail log bucket arn (if the customer specify the name of cloudtrail log bucket)"
  default     = ""
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "kinesis_stream_arn" {
  description = "ARN for kinesis data stream for cloudtrail logs (if the customer specify the name of kinesis stream)"
  type        = string
  default     = ""
}

