variable "tags" {
  type = map(string)
  default = {
    owner     = "angel.rengifo"
    tfproject = "aws-tfe-vault"
  }
}

provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.38.0"

  name                   = "tfe-vpc"
  cidr                   = "192.168.10.0/24"
  azs                    = ["us-east-1a", "us-east-1b"]
  private_subnets        = ["192.168.10.0/27", "192.168.10.32/27"]
  public_subnets         = ["192.168.10.128/27", "192.168.10.160/27"]
  tags                   = var.tags
  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false
}

module "ami_tfe" {
  source = "../../../../terraform-aws-data-amis/"
  os     = "Ubuntu Server 18.04"
}

module "ami_bastion" {
  source = "../../../../terraform-aws-data-amis/"
  os     = "Ubuntu Server 18.04"
}

module "ami_vault" {
  source = "../../../../terraform-aws-data-amis/"
  os     = "Ubuntu Server 18.04"
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
  ami                         = module.ami_bastion.id
  instance_type               = "t3a.small"
  key_name                    = "kp-angel.rengifo"
  monitoring                  = false
  vpc_security_group_ids      = [module.sg_bastion.this_security_group_id]
  subnet_ids                  = module.vpc.public_subnets
  associate_public_ip_address = true
  tags                        = var.tags
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
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH service"
      cidr_blocks = "192.168.10.0/24"
    },
    {
      from_port   = 8200
      to_port     = 8200
      protocol    = "tcp"
      description = "Vault service"
      cidr_blocks = "192.168.10.0/24"
    }
  ]
}

module "ec2_vault" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "2.13.0"

  instance_count              = 1
  name                        = "vault"
  ami                         = module.ami_vault.id
  instance_type               = "t3a.small"
  key_name                    = "kp-angel.rengifo"
  monitoring                  = false
  vpc_security_group_ids      = [module.sg_vault.this_security_group_id]
  subnet_ids                  = module.vpc.private_subnets
  associate_public_ip_address = false
  tags                        = var.tags
}

module "sg_tfe" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "3.10.0"

  name         = "sg_tfe"
  description  = "SG for TFE hosts"
  vpc_id       = module.vpc.vpc_id
  egress_rules = ["all-all"]
  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH service"
      cidr_blocks = "192.168.10.0/24"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "HTTPS service"
      cidr_blocks = "192.168.10.0/24"
    },
    {
      from_port   = 8800
      to_port     = 8800
      protocol    = "tcp"
      description = "TFE installer service"
      cidr_blocks = "192.168.10.0/24"
    },
    {
      from_port   = 9870
      to_port     = 9880
      protocol    = "tcp"
      description = "Internal TFE communication"
      cidr_blocks = "192.168.10.0/24"
    },
    {
      from_port   = 23000
      to_port     = 23100
      protocol    = "tcp"
      description = "Internal TFE communication"
      cidr_blocks = "192.168.10.0/24"
    }
  ]
}

module "ec2_tfe" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "2.13.0"

  instance_count              = 1
  name                        = "tfe"
  ami                         = module.ami_tfe.id
  instance_type               = "t3a.large"
  key_name                    = "kp-angel.rengifo"
  monitoring                  = false
  vpc_security_group_ids      = [module.sg_tfe.this_security_group_id]
  subnet_ids                  = module.vpc.private_subnets
  associate_public_ip_address = false
  iam_instance_profile        = aws_iam_instance_profile.tfe.name
  tags                        = var.tags
  user_data                   = <<EOF
#!/bin/bash
apt-get update
apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get install -y docker-ce docker-ce-cli containerd.io
EOF

  root_block_device = [
    {
      delete_on_termination = true
      encrypted             = false
      # kms_key_id            = aws_kms_key.tfe.arn
      volume_size           = "40"
      volume_type           = "gp2"
    }
  ]
}

module "sg_rds" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "3.10.0"

  name         = "sg_rds"
  description  = "SG for RDS instance"
  vpc_id       = module.vpc.vpc_id
  egress_rules = ["all-all"]
  ingress_with_cidr_blocks = [
    {
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      description = "Postgres service"
      cidr_blocks = "192.168.10.0/24"
    }
  ]
}

module "rds" {
  source     = "terraform-aws-modules/rds/aws"
  version    = "2.16.0"
  identifier = "db-tfe"

  engine                  = "postgres"
  engine_version          = "9.6.18"
  instance_class          = "db.t3.small"
  allocated_storage       = 5
  storage_encrypted       = false
  # kms_key_id              = aws_kms_key.tfe.arn
  name                    = "tfe"
  username                = "arengifo"
  password                = "Peru2020.."
  port                    = "5432"
  vpc_security_group_ids  = [module.sg_rds.this_security_group_id]
  maintenance_window      = "Mon:00:00-Mon:03:00"
  backup_window           = "03:00-06:00"
  backup_retention_period = 0
  subnet_ids              = module.vpc.private_subnets
  family                  = "postgres9.6"
  major_engine_version    = "9.6"
  deletion_protection     = false
  tags                    = var.tags
  # enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]
  # final_snapshot_identifier = "demodb"
}

resource "aws_s3_bucket" "tfe" {
  bucket = "company-tfe-bucket"
  tags   = var.tags

  # server_side_encryption_configuration {
  #   rule {
  #     apply_server_side_encryption_by_default {
  #       kms_master_key_id = aws_kms_key.tfe.arn
  #       sse_algorithm     = "aws:kms"
  #     }
  #   }
  # }
}

# resource "aws_kms_key" "tfe" {
#   description             = "KMS key for TFE data encryption"
#   deletion_window_in_days = 7
#   tags                    = var.tags
# }

# resource "aws_kms_alias" "tfe" {
#   name_prefix   = "alias/tfe_"
#   target_key_id = aws_kms_key.tfe.id
# }

resource "aws_iam_role" "tfe" {
  name = "tfe-iam_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "tfe" {
  name = "tfe-iam_instance_profile"
  role = aws_iam_role.tfe.name
}

data "aws_iam_policy_document" "tfe" {
  statement {
    sid    = "AllowS3a"
    effect = "Allow"

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.tfe.id}",
    ]

    actions = [
      "s3:*",
    ]
  }
  statement {
    sid    = "AllowS3b"
    effect = "Allow"

    resources = [
      "arn:aws:s3:::*"
    ]

    actions = [
      "s3:ListAllMyBuckets",
    ]
  }
  statement {
    sid    = "AllowS3c"
    effect = "Allow"

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.tfe.id}/*"
    ]

    actions = [
      "s3:*",
    ]
  }
  # statement {
  #   sid    = "AllowKMS"
  #   effect = "Allow"

  #   resources = [
  #     "arn:aws:kms:::key/${aws_kms_key.tfe.id}"
  #   ]

  #   actions = [
  #     "kms:*",
  #   ]
  # }
}

resource "aws_iam_role_policy" "tfe" {
  name   = "tfe-iam_role_policy"
  role   = aws_iam_role.tfe.name
  policy = data.aws_iam_policy_document.tfe.json
}

# resource "aws_directory_service_directory" "ad" {
#   type        = "SimpleAD"
#   description = "Active Directory Service for integration with Terraform"
#   name        = "solucionescompany.com"
#   short_name  = "COMPANY"
#   password    = "Peru2020.."
#   size        = "Small"
#   tags        = var.tags

#   vpc_settings {
#     vpc_id     = module.vpc.vpc_id
#     subnet_ids = module.vpc.private_subnets
#   }
# }

