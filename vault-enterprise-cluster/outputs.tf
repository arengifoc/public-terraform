output "bastion_public_ip_pri" {
  value = module.ec2_bastion.public_ip
}

output "vault_private_ips_pri" {
  value = module.ec2_vault.private_ip
}

output "consul_private_ips_pri" {
  value = module.ec2_consul.private_ip
}

output "bastion_public_ip_sec" {
  value = module.ec2_bastion_sec.public_ip
}

output "vault_private_ips_sec" {
  value = module.ec2_vault_sec.private_ip
}

output "consul_private_ips_sec" {
  value = module.ec2_consul_sec.private_ip
}

output "access_key" {
  value = aws_iam_access_key.iam_access_key.id
}

output "secret_key" {
  value = aws_iam_access_key.iam_access_key.secret
}

output "kms_key_pri" {
  value = aws_kms_key.vault_key_pri.key_id
}

output "kms_key_sec" {
  value = aws_kms_key.vault_key_sec.key_id
}

