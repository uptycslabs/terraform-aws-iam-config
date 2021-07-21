output "instance_profile_arn" {
  description = "The deployed instance name"
  value       = module.instance_profile.instance_profile_arn
}

output "aws_iam_role_arn" {
  description = "The aws role arn ."
  value       = module.instance_profile.aws_iam_role_arn
}


