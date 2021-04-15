provider "aws" {
  region = "us-east-1"
}

module "sg_vault" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "3.10.0"

  name         = "sg_vault"
  description  = "SG for vault enterprise hosts"
  vpc_id       = var.vpc_id
  egress_rules = ["all-all"]
  ingress_with_cidr_blocks = [
    {
      from_port   = 8300
      to_port     = 8301
      protocol    = "tcp"
      description = "Consul ports"
      cidr_blocks = "10.0.0.0/24"
    },
    {
      from_port   = 8200
      to_port     = 8201
      protocol    = "tcp"
      description = "Vault ports allowed from primary site"
      cidr_blocks = "10.0.0.0/24"
    },
    {
      from_port   = 8200
      to_port     = 8201
      protocol    = "tcp"
      description = "Vault ports allowed from secondary site"
      cidr_blocks = "172.31.16.0/20"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH service"
      cidr_blocks = "10.0.0.0/16"
    }
  ]
}

module "sg_consul" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "3.10.0"

  name         = "sg_consul"
  description  = "SG for consul enterprise hosts"
  vpc_id       = var.vpc_id
  egress_rules = ["all-all"]
  ingress_with_cidr_blocks = [
    {
      from_port   = 8300
      to_port     = 8302
      protocol    = "tcp"
      description = "Consul ports"
      cidr_blocks = "10.0.0.0/24"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH service"
      cidr_blocks = "10.0.0.0/16"
    }
  ]
}

module "sg_bastion" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "3.10.0"

  name         = "sg_bastion"
  description  = "SG for bastion host"
  vpc_id       = var.vpc_id
  egress_rules = ["all-all"]
  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH service"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}

module "ec2_vault" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "2.13.0"

  instance_count              = 2
  name                        = "ent_vault"
  ami                         = "ami-0b898040803850657"
  instance_type               = "t3a.micro"
  key_name                    = "kp-angel.rengifo"
  monitoring                  = false
  vpc_security_group_ids      = [module.sg_vault.this_security_group_id]
  subnet_ids                  = var.subnet_ids
  associate_public_ip_address = true
  tags                        = var.tags
}

module "ec2_consul" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "2.13.0"

  instance_count              = 3
  name                        = "ent_consul"
  ami                         = "ami-0b898040803850657"
  instance_type               = "t3a.micro"
  key_name                    = "kp-angel.rengifo"
  monitoring                  = false
  vpc_security_group_ids      = [module.sg_consul.this_security_group_id]
  subnet_ids                  = var.subnet_ids
  associate_public_ip_address = true
  tags                        = var.tags
}


module "ec2_bastion" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "2.13.0"

  instance_count              = 1
  name                        = "ent_bastion"
  ami                         = "ami-0b898040803850657"
  instance_type               = "t3a.micro"
  key_name                    = "kp-angel.rengifo"
  monitoring                  = false
  vpc_security_group_ids      = [module.sg_bastion.this_security_group_id]
  subnet_ids                  = var.subnet_ids
  associate_public_ip_address = true
  user_data                   = <<EOF
#!/bin/bash
amazon-linux-extras enable ansible2
yum install -y tmux jq ansible python2-pip
pip install --upgrade jinja2
EOF
  tags                        = var.tags
}

resource "aws_kms_key" "vault_key_pri" {
  description             = "Primary KMS key for unsealing Vault"
  deletion_window_in_days = 7
  tags                    = var.tags
}

resource "aws_kms_alias" "vault_key_alias_pri" {
  name_prefix   = "alias/vault_key_"
  target_key_id = aws_kms_key.vault_key_pri.id
}

