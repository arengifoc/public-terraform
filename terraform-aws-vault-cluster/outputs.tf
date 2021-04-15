output "vault_access_key" {
  value = var.create_kms_key == true ? aws_iam_access_key.iam_access_key[0].id : null
}

output "vault_secret_key" {
  value = var.create_kms_key == true ? aws_iam_access_key.iam_access_key[0].secret : null
}

output "kms_key_id" {
  value = var.create_kms_key == true ? aws_kms_key.vault_key[0].id : null
}

output "consul_ips" {
  value = module.ec2_consul.private_ip
}

output "vault_ips" {
  value = module.ec2_vault.private_ip
}

output "bastion_public_ip" {
  value = module.ec2_bastion.public_ip
}

output "elb_dns_name" {
  value = "${module.elb.this_lb_dns_name}:${var.vault_port}"
}
