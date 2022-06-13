module "instance_profile" {
  source         = "./modules/iam-profile"
  aws_account_id = var.aws_account_id
  external_id    = var.external_id
  tags           = var.tags
  child_account_name = var.child_account_name
  child_account_id = var.child_account_id
}
