resource "aws_key_pair" "keypair" {
  key_name_prefix = var.name_prefix
  public_key      = var.public_sshkey
}

module "ami" {
  source = "git::https://gitlab.com/arengifoc/terraform-aws-data-amis"
  os     = var.os
}


module "sg_ec2" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "3.16.0"

  name         = "${var.name_prefix}-sg-ec2"
  description  = "SG for ec2 host"
  vpc_id       = module.network.vpc_id
  egress_rules = ["all-all"]
  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH service"
      cidr_blocks = module.network.vpc_cidr_block
    }
  ]
}


module "ec2_ec2" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "2.15.0"

  instance_count              = var.webapp_count
  name                        = "${var.name_prefix}-ec2"
  ami                         = module.ami.id
  instance_type               = var.vm-size
  key_name                    = aws_key_pair.keypair.key_name
  monitoring                  = false
  vpc_security_group_ids      = [module.sg_ec2.this_security_group_id]
  subnet_ids                  = module.network.private_subnets
  associate_public_ip_address = true
  tags                        = var.tags
}
