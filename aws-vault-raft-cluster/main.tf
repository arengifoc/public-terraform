provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "FAMRENCAR"

    workspaces {
      name = "aws-vault-raft-cluster"
    }
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.38.0"

  name               = var.vpc_name
  cidr               = var.vpc_cidr
  azs                = var.azs
  public_subnets     = var.public_subnets
  tags               = var.tags
  enable_nat_gateway = false
}

module "ami" {
  source = "app.terraform.io/FAMRENCAR/data-amis/aws"
  os     = "Ubuntu Server 18.04"
}

module "sg_vault" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "3.10.0"

  name         = "sg_vault"
  description  = "SG for vault hosts"
  vpc_id       = module.vpc.vpc_id
  egress_rules = ["all-all"]
  ingress_with_cidr_blocks = [
    {
      from_port   = 8300
      to_port     = 8301
      protocol    = "tcp"
      description = "Consul ports"
      cidr_blocks = module.vpc.vpc_cidr_block
    },
    {
      from_port   = 8200
      to_port     = 8201
      protocol    = "tcp"
      description = "Vault ports allowed"
      cidr_blocks = module.vpc.vpc_cidr_block
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH service"
      cidr_blocks = module.vpc.vpc_cidr_block
    }
  ]
}

module "ec2_vault" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "2.13.0"

  instance_count              = 3
  name                        = "vaultraft"
  ami                         = module.ami.id
  instance_type               = "t3a.small"
  key_name                    = "kp-angel.rengifo"
  monitoring                  = false
  vpc_security_group_ids      = [module.sg_vault.this_security_group_id]
  subnet_ids                  = module.vpc.public_subnets
  associate_public_ip_address = true
  tags                        = var.tags
}

module "sg_bastion" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "3.10.0"

  name         = "sg_bastion"
  description  = "SG for bastion hosts"
  vpc_id       = module.vpc.vpc_id
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

module "ec2_bastion" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "2.13.0"

  instance_count              = 1
  name                        = "bastion"
  ami                         = module.ami.id
  instance_type               = "t3a.small"
  key_name                    = "kp-angel.rengifo"
  monitoring                  = false
  vpc_security_group_ids      = [module.sg_bastion.this_security_group_id]
  subnet_ids                  = module.vpc.public_subnets
  associate_public_ip_address = true
  tags                        = var.tags
  user_data                   = <<EOF
#!/bin/bash
apt-get update
apt-get install -y ansible tmux
EOF
}

resource "aws_kms_key" "vault_key" {
  description             = "KMS key for unsealing Vault"
  deletion_window_in_days = 7
  tags                    = var.tags
}

resource "aws_kms_alias" "vault_key_alias" {
  name_prefix   = "alias/vault_key_"
  target_key_id = aws_kms_key.vault_key.id
}

resource "aws_iam_user" "iam_user" {
  name          = "vault_unseal_user"
  force_destroy = true
  tags          = var.tags
}

resource "aws_iam_access_key" "iam_access_key" {
  user = aws_iam_user.iam_user.name
}

# IAM Inlice Policy for Vault IAM User
# This policy allows only the required seal/unseal tasks in Vault
resource "aws_iam_user_policy" "iam_user_policy" {
  user        = aws_iam_user.iam_user.name
  name_prefix = "kms_policy_"
  policy      = data.aws_iam_policy_document.user_policy.json
}

data "aws_iam_policy_document" "user_policy" {
  statement {
    sid    = "KMSUsage"
    effect = "Allow"

    resources = [
      "${aws_kms_key.vault_key.arn}"
    ]

    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:DescribeKey"
    ]
  }
}
