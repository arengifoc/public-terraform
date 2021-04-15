# terraform {
#   backend "remote" {
#     hostname     = "app.terraform.io"
#     organization = "FAMRENCAR"

#     workspaces {
#       name = "vault-aws-network"
#     }
#   }
# }

provider "aws" {
  alias  = "primary"
  region = var.primary_region
}

provider "aws" {
  alias  = "secondary"
  region = var.secondary_region
}

module "primary_vpc" {
  providers = {
    aws = aws.primary
  }
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.38.0"

  name            = var.primary_vpc_name
  cidr            = var.primary_vpc_cidr
  azs             = var.primary_azs
  private_subnets = var.primary_private_subnets
  public_subnets  = var.primary_public_subnets
  tags            = var.tags

  enable_nat_gateway     = true
  single_nat_gateway     = false
  one_nat_gateway_per_az = true
}

module "secondary_vpc" {
  providers = {
    aws = aws.secondary
  }
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.38.0"

  create_vpc      = var.secondary_vpc_name != null && var.secondary_vpc_cidr != null && var.secondary_azs != [] && var.secondary_private_subnets != [] && var.secondary_public_subnets != [] ? true : false
  name            = var.secondary_vpc_name
  cidr            = var.secondary_vpc_cidr
  azs             = var.secondary_azs
  private_subnets = var.secondary_private_subnets
  public_subnets  = var.secondary_public_subnets
  tags            = var.tags

  enable_nat_gateway     = true
  single_nat_gateway     = false
  one_nat_gateway_per_az = true
}

