output "instance_profile_arn" {
  description = "Instance profile arn"
  value       = aws_iam_instance_profile.instance_profile.arn
}

output "aws_iam_role_arn" {
  description = "aws iam role arn"
  value       = aws_iam_role.role.arn
}

