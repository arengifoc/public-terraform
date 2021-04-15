output "primary_vpc_id" {
  value = module.primary_vpc.vpc_id
}

output "primary_vpc_cidr_block" {
  value = module.primary_vpc.vpc_cidr_block
}

output "primary_private_subnet_ids" {
  value = module.primary_vpc.private_subnets
}

output "primary_public_subnet_ids" {
  value = module.primary_vpc.public_subnets
}

output "primary_private_subnet_cidrs" {
  value = module.primary_vpc.private_subnets_cidr_blocks
}

output "secondary_vpc_id" {
  value = module.secondary_vpc.vpc_id
}

output "secondary_vpc_cidr_block" {
  value = module.secondary_vpc.vpc_cidr_block
}

output "secondary_private_subnet_ids" {
  value = module.secondary_vpc.private_subnets
}

output "secondary_public_subnet_ids" {
  value = module.secondary_vpc.public_subnets
}

output "secondary_private_subnet_cidrs" {
  value = module.secondary_vpc.private_subnets_cidr_blocks
}
