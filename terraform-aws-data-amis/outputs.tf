output "id" {
  value       = data.aws_ami.selected.id
  description = "AMI ID"
}

output "default_user" {
  value       = var.amis[var.os].default_user
  description = "Default user for getting access to operating system using keypair"
}
