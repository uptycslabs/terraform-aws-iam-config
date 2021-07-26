output "aws_iam_role_arn" {
  description = "The aws role arn ."
  value       = module.instance_profile.aws_iam_role_arn
}

output "external_id" {
  description = "Passed UUID as external id for access config."
  value = var.external_id
}