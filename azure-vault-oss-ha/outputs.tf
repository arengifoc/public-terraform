output "primary_bastion_public_ip" {
  value = module.primary_bastion.public_ip
}

output "primary_vault_private_ip" {
  value = module.primary_vault.private_ip
}

# output "secondary_bastion_public_ip" {
#   value = module.secondary_bastion.public_ip
# }

# output "secondary_vault_private_ip" {
#   value = module.secondary_vault.private_ip
# }
