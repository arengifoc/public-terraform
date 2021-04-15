output "access_key" {
  value = module.primary.vault_access_key
}

output "secret_key" {
  value = module.primary.vault_secret_key
}

output "kms_key" {
  value = module.primary.kms_key_id
}

output "primary_consul_ips" {
    value = module.primary.consul_ips
}

output "primary_vault_ips" {
    value = module.primary.vault_ips
}

output "primary_bastion_public_ip" {
    value = module.primary.bastion_public_ip
}

output "primary_lb_url" {
    value = "https://${module.primary.elb_dns_name}"
}

# output "secondary_consul_ips" {
#     value = module.secondary.consul_ips
# }

# output "secondary_vault_ips" {
#     value = module.secondary.vault_ips
# }

# output "secondary_bastion_public_ip" {
#     value = module.secondary.bastion_public_ip
# }

# output "secondary_lb_url" {
#     value = "https://${module.secondary.elb_dns_name}"
# }
