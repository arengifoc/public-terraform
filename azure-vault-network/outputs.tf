output "primary_subnet_ids" {
  value = module.primary_vnet.vnet_subnets
}

output "secondary_subnet_ids" {
  value = module.secondary_vnet.vnet_subnets
}

output "primary_subnet_cidrs" {
  value = var.primary_subnet_cidr
}

output "secondary_subnet_cidrs" {
  value = var.secondary_subnet_cidr
}
