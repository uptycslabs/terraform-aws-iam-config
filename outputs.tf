output "aws_iam_role_arn" {
  description = "AWS role ARN and externalid"
  value       = module.instance_profile.aws_iam_role_arn
}