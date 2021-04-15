module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.44.0"

  name                   = var.vpc_name
  cidr                   = var.vpc_cidr_block
  azs                    = length(var.az_names) == 0 ? slice(data.aws_availability_zones.default.names, 0, 3) : var.az_names
  private_subnets        = var.private_subnet_cidr_blocks
  public_subnets         = var.public_subnet_cidr_blocks
  tags                   = var.tags
  enable_nat_gateway     = var.enable_nat_gw
  single_nat_gateway     = var.enable_nat_gw
  one_nat_gateway_per_az = !var.enable_nat_gw
}

data "aws_availability_zones" "default" {
  state = "available"
}
