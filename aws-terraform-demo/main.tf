variable "tags" {
  type = map(string)
  default = {
    owner     = "angel.rengifo"
    team      = "presales"
    tfproject = "aws-terraform-demo"
  }
}

provider "aws" {
  region = "us-east-1"
}

module "rds" {
  source = "../../../../terraform-aws-rds/"

  identifier           = "dbdemo"
  subnet_ids           = module.network.private_subnet_ids
  master_password      = "P4k42020.."
  master_username      = "companyadmin"
  engine               = "postgres"
  engine_version       = "9.6.18"
  engine_major_version = "9.6"
  allowed_cidr_block   = module.network.vpc_cidr_block
  tags                 = var.tags
}

module "network" {
  source = "../../../../terraform-aws-network/"

  vpc_name                   = "demo-vpc"
  vpc_cidr_block             = "192.168.10.0/24"
  tags                       = var.tags
  enable_nat_gw              = false
  az_names                   = ["us-east-1a", "us-east-1b"]
  private_subnet_cidr_blocks = ["192.168.10.0/27", "192.168.10.32/27"]
  # public_subnet_cidr_blocks  = ["192.168.10.128/27", "192.168.10.160/27"]
}

output "endpoint" {
  value = module.rds.endpoint
}
