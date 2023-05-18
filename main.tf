data "aws_s3_bucket" "vpc_log_bucket_arn" {
  count  = var.vpc_flowlogs_bucket_name != "" ? 1 : 0
  bucket = var.vpc_flowlogs_bucket_name
}

data "aws_s3_bucket" "cloudtrail_log_bucket_arn" {
  count  = var.cloudtrail_s3_bucket_name != "" ? 1 : 0
  bucket = var.cloudtrail_s3_bucket_name
}

data "aws_kinesis_stream" "kinesis_stream_arn" {
  count = var.kinesis_stream_name != "" ? 1 : 0
  name  = var.kinesis_stream_name
}

module "instance_profile" {
  source                    = "./modules/iam-profile"
  resource_prefix           = var.resource_prefix
  aws_account_id            = var.aws_account_id
  external_id               = var.external_id
  cloudtrail_log_bucket_arn = var.cloudtrail_s3_bucket_name != "" ? data.aws_s3_bucket.cloudtrail_log_bucket_arn[0].arn : null
  vpc_log_bucket_arn        = var.vpc_flowlogs_bucket_name != ""  ? data.aws_s3_bucket.vpc_log_bucket_arn[0].arn : null
  kinesis_stream_arn        = var.kinesis_stream_name != "" ? data.aws_kinesis_stream.kinesis_stream_arn[0].arn : null
  tags                      = var.tags
}
