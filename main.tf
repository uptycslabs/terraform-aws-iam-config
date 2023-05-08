data "aws_region" "current" {}

module "cloud_trail_bucket_details" {
  source          = "./bucket_details"
  resource_region = var.cloudtrail_s3_bucket_region != "" ? var.cloudtrail_s3_bucket_region : data.aws_region.current.id
  bucket_name     = var.cloudtrail_s3_bucket_name
}

module "vpc_flow_log_bucket_details" {
  source          = "./bucket_details"
  resource_region = var.vpc_flowlogs_bucket_region != "" ? var.vpc_flowlogs_bucket_region : data.aws_region.current.id
  bucket_name     = var.vpc_flowlogs_bucket_name
}

module "kinesis_stream_deatils" {
  source                = "./kinesis_details"
  kinesis_stream_region = var.kinesis_stream_region != "" ? var.kinesis_stream_region : data.aws_region.current.id
  kinesis_stream_name   = var.kinesis_stream_name
}

locals {
  cloudtrail_log_bucket_arn = var.cloudtrail_s3_bucket_name != "" ? module.cloud_trail_bucket_details.bucket_arn : null
  vpc_log_bucket_arn        = var.vpc_flowlogs_bucket_name != "" ? module.vpc_flow_log_bucket_details.bucket_arn : null
  kinesis_stream_arn        = var.kinesis_stream_name != "" ? module.kinesis_stream_deatils.kinesis_stream_arn : null
}

module "instance_profile" {
  source                    = "./modules/iam-profile"
  resource_prefix           = var.resource_prefix
  aws_account_id            = var.aws_account_id
  external_id               = var.external_id
  cloudtrail_log_bucket_arn = local.cloudtrail_log_bucket_arn
  vpc_log_bucket_arn        = local.vpc_log_bucket_arn
  kinesis_stream_arn        = local.kinesis_stream_arn
  tags                      = var.tags
}
