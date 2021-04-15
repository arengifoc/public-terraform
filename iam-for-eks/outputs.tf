output "role_arn" {
  value = aws_iam_role.iam-role-eks.arn
}

output "instance-profile-arn" {
  value       = aws_iam_instance_profile.iam-instance-profile-eks.arn
  description = "ARN del instance profile"
}
