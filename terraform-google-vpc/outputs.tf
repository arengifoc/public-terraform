output "network_name" {
  value = module.vpc.network_name
}

output "subnets_names" {
  value = module.vpc.subnets_names
}

output "subnets_cidrs" {
  value = module.vpc.subnets_ips
}

output "subnets" {
  value = module.vpc.subnets
}
