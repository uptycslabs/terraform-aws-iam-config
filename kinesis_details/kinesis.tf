variable "kinesis_stream_region" {
  type = string
}

variable "kinesis_stream_name" {
  type = string
}

provider "aws" {
  region = var.kinesis_stream_region
}


data "aws_kinesis_stream" "kinesis_stream_arn" {
  count = var.kinesis_stream_name != "" ? 1 : 0
  name  = var.kinesis_stream_name
}

output "kinesis_stream_arn" {
  value = var.kinesis_stream_name != "" ? data.aws_kinesis_stream.kinesis_stream_arn[0].arn:null
}
