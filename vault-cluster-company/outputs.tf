output "primary_consul_private_ips" {
  value = local.primary_consul_ips
}

output "primary_vault_private_ips" {
  value = module.primary_vault_ec2_instances.private_ip
}

output "primary_bastion_public_ip" {
  value = module.primary_bastion_ec2_instance.public_ip
}

output "secondary_consul_private_ips" {
  value = local.secondary_consul_ips
}

output "secondary_vault_private_ips" {
  value = local.secondary_vault_ips
}

output "secondary_bastion_public_ip" {
  value = local.secondary_consul_ips
}

output "ssh_user" {
  value = lookup(var.amis[var.desired_os], "default_user", "unknown")
}

# output "dc_ip_addresses" {
#   value = aws_directory_service_directory.ad.dns_ip_addresses
# }

# output "primary_alb_url" {
#   value = "${lower(var.alb_listener_protocol)}://${module.primary_alb.this_lb_dns_name}:${var.alb_listener_port}"
# }

# output "secondary_alb_url" {
#   value = "${lower(var.alb_listener_protocol)}://${module.secondary_alb.this_lb_dns_name}:${var.alb_listener_port}"
# }
