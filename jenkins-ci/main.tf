variable "tags" {
  type = map(string)
  default = {
    owner     = "angel.rengifo"
    tfproject = "jenkins-ci"
  }
}

provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.38.0"

  name               = "vpc_jenkins"
  cidr               = "192.168.20.0/24"
  azs                = ["us-east-1a", "us-east-1b"]
  public_subnets     = ["192.168.20.0/27"]
  private_subnets    = ["192.168.20.32/27"]
  tags               = var.tags
  enable_nat_gateway = false
}

module "ami_jenkins" {
  source = "../../../../terraform-aws-data-amis/"
  os     = "Ubuntu Server 18.04"
}

module "sg_jenkinsmaster" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "3.10.0"

  name         = "sg_jenkinsmaster"
  description  = "SG for jenkinsmaster hosts"
  vpc_id       = module.vpc.vpc_id
  egress_rules = ["all-all"]
  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH service"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      description = "Jenkins service"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 3128
      to_port     = 3128
      protocol    = "tcp"
      description = "Squid service"
      cidr_blocks = module.vpc.vpc_cidr_block
    }
  ]
}

module "ec2_jenkinsmaster" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "2.13.0"

  instance_count              = 1
  name                        = "jenkinsmaster"
  ami                         = module.ami_jenkins.id
  instance_type               = "t3a.small"
  key_name                    = "kp-angel.rengifo"
  monitoring                  = false
  vpc_security_group_ids      = [module.sg_jenkinsmaster.this_security_group_id]
  subnet_ids                  = module.vpc.public_subnets
  associate_public_ip_address = true
  tags                        = var.tags
}

module "sg_jenkinsnode" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "3.10.0"

  name         = "sg_jenkinsnode"
  description  = "SG for jenkinsnode hosts"
  vpc_id       = module.vpc.vpc_id
  egress_rules = ["all-all"]
  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH service"
      cidr_blocks = module.vpc.vpc_cidr_block
    }
  ]
}

module "ec2_jenkinsnode" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "2.13.0"

  instance_count              = 1
  name                        = "jenkinsnode"
  ami                         = module.ami_jenkins.id
  instance_type               = "t3a.small"
  key_name                    = "kp-angel.rengifo"
  monitoring                  = false
  vpc_security_group_ids      = [module.sg_jenkinsnode.this_security_group_id]
  subnet_ids                  = module.vpc.private_subnets
  associate_public_ip_address = false
  tags                        = var.tags
}


output "jenkinsmaster_public_ip" {
    value = module.ec2_jenkinsmaster.public_ip
}

output "jenkinsmaster_private_ip" {
    value = module.ec2_jenkinsmaster.private_ip
}

output "jenkinsnode_private_ip" {
    value = module.ec2_jenkinsnode.private_ip
}