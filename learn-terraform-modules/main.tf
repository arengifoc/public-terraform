# Terraform configuration
terraform {
  backend "s3" {
    bucket         = "company-terraform-states"
    key            = "dev/learn-terraform-modules/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "company-terraform-states-locking"
  }
}

provider "aws" {
  region = "us-east-1"
  # region = "us-west-2"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.21.0"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs             = var.vpc_azs
  private_subnets = var.vpc_private_subnets
  public_subnets  = var.vpc_public_subnets

  enable_nat_gateway = var.vpc_enable_nat_gateway
  single_nat_gateway = false
  one_nat_gateway_per_az = true

  tags = var.common_tags
}

module "ec2_instances" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "2.12.0"

  name           = "demo-vm-tfmodules"
  instance_count = 1

  ami                    = "ami-0323c3dd2da7fb37d"
  instance_type          = "t3a.nano"
  vpc_security_group_ids = [module.vpc.default_security_group_id]
  subnet_id              = module.vpc.public_subnets[0]

  tags = var.common_tags
}
