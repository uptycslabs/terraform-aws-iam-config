output "aws_iam_role_arn" {
  description = "AWS role ARN"
  value       = module.instance_profile.aws_iam_role_arn
}