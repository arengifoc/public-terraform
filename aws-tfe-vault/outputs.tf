output "bastion_public_ip" {
  value = module.ec2_bastion.public_ip[0]
}

output "vault_private_ip" {
  value = module.ec2_vault.private_ip[0]
}

output "tfe_private_ip" {
  value = module.ec2_tfe.private_ip[0]
}

output "rds_address" {
  description = "The address of the RDS instance"
  value       = module.rds.this_db_instance_address
}

output "s3_bucket" {
  value = aws_s3_bucket.tfe.id
}

# output "kms_key_id" {
#   value = aws_kms_key.tfe.id
# }

# output "dc_ip_addresses" {
#   value = aws_directory_service_directory.ad.dns_ip_addresses
# }
