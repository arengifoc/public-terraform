module "network" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.63.0"

  name                   = "${var.name_prefix}-vpc"
  cidr                   = var.network_cidr
  azs                    = var.zone_names
  public_subnets         = var.public_subnet_cidrs
  private_subnets        = var.private_subnet_cidrs
  tags                   = var.tags
  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false
}
