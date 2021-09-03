provider "aws" {}

###################
# Local variables #
###################
locals {
  ec2_prefix = var.random_suffix ? "${var.name_prefix}-${random_id.this.hex}" : var.name_prefix
  tags = merge(
    var.tags,
    {
      "description" = "Managed by terraform",
    }
  )
}

###########
# Modules #
###########
module "ami" {
  source = "git::https://gitlab.com/arengifoc/terraform-aws-data-amis"
  os     = var.desired_os
}

module "ec2" {
  source                      = "terraform-aws-modules/ec2-instance/aws"
  version                     = "2.19.0"
  instance_count              = var.instance_count
  name                        = "ec2-${local.ec2_prefix}"
  ami                         = var.ami_id != "" ? var.ami_id : module.ami.id
  instance_type               = var.instance_type
  key_name                    = var.create_keypair ? aws_key_pair.this[0].key_name : var.keypair_name
  monitoring                  = var.detailed_monitoring
  vpc_security_group_ids      = var.create_sg ? [module.sg_ec2.security_group_id] : var.sg_ids
  subnet_ids                  = [var.subnet_id]
  associate_public_ip_address = var.assign_public_ip
  user_data                   = var.user_data
  iam_instance_profile        = aws_iam_instance_profile.instance_profile.id
  tags                        = local.tags
  root_block_device = [
    {
      volume_size = var.root_block_device_size
      volume_type = var.root_block_device_type
    }
  ]
}

module "sg_ec2" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.3.0"

  name         = "sg_${local.ec2_prefix}"
  description  = "SG for the ec2-${local.ec2_prefix} EC2 instance"
  vpc_id       = data.aws_subnet.selected.vpc_id
  egress_rules = ["all-all"]
  tags         = local.tags

  ingress_with_cidr_blocks = [
    for rule in var.sg_rules :
    {
      from_port   = element(split(",", rule), 0)
      to_port     = element(split(",", rule), 0)
      protocol    = element(split(",", rule), 1)
      cidr_blocks = element(split(",", rule), 2)
    }
  ]
}

#############
# Resources #
#############
resource "random_id" "this" {
  byte_length = 2
  keepers = {
    desired_os = var.desired_os
  }
}

resource "aws_key_pair" "this" {
  count = var.create_keypair ? 1 : 0

  key_name   = "kp-${local.ec2_prefix}"
  public_key = file(var.pubkey)
  tags       = local.tags
}

resource "aws_iam_role" "iam_role" {
  name               = "role-${local.ec2_prefix}"
  path               = var.iam_path
  assume_role_policy = data.aws_iam_policy_document.assumerole_policy_document.json
  tags               = local.tags
}

resource "aws_iam_policy" "iam_role_policy" {
  name   = "policy-${local.ec2_prefix}"
  path   = var.iam_path
  policy = var.iam_json_policy
  tags   = local.tags
}

resource "aws_iam_role_policy_attachment" "iam_role_policy_attachment" {
  role       = aws_iam_role.iam_role.name
  policy_arn = aws_iam_policy.iam_role_policy.arn
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = "instanceprofile-${local.ec2_prefix}"
  role = aws_iam_role.iam_role.name
}

################
# Data sources #
################

data "aws_iam_policy_document" "ec2_iam_policy_document" {
  statement {
    sid = "EC2ReadOnly"
    actions = [
      "ec2:*",
      "s3:*"
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "assumerole_policy_document" {
  statement {
    sid     = "AssumeRole"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_subnet" "selected" {
  id = var.subnet_id
}
