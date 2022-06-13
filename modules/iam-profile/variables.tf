variable "aws_account_id" {
  description = "Aws account id of Uptycs"
  type        = string
}

variable "external_id" {
  description = "ExternalId to be used for API authentication."
  type        = string
}
variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "child_account_id" {
  description = "Aws child account id"
  type = string

}

variable "child_account_name" {
  description = "Aws child account name"
  type = string
  
}
