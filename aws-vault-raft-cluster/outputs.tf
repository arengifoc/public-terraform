output "bastion_public_ip" {
  value = module.ec2_bastion.public_ip
}

output "vault_private_ips" {
  value = module.ec2_vault.private_ip
}

output "access_key" {
  value = aws_iam_access_key.iam_access_key.id
}

output "secret_key" {
  value = aws_iam_access_key.iam_access_key.secret
}

output "kms_key" {
  value = aws_kms_key.vault_key.key_id
}

