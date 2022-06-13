output "aws_iam_role_arn" {
  description = "aws iam role arn"
  value       = { 
    rolearn = aws_iam_role.role.arn
    extid = var.external_id
  }
}