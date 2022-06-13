variable "aws_account_id" {
  description = "Uptycs AWS account ID"
  type        = string
}

variable "external_id" {
  description = "Role external ID provided by Uptycs"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the resources created by this module"
  type        = map(string)
  default     = {}
}

variable "child_account_id" {
  description = "Aws child account id"
  type        = string

}

variable "child_account_name" {
  description = "Aws child account name"
  type        = string

}