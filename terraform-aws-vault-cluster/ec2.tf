# Create a security group for consul servers
module "sg_consul" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "3.10.0"

  name         = var.sg_consul_name
  description  = var.sg_consul_description
  vpc_id       = var.vpc_id
  egress_rules = ["all-all"]
  ingress_with_cidr_blocks = [
    {
      from_port   = var.consul_port
      to_port     = var.consul_port + 2
      protocol    = "tcp"
      description = "Consul ports"
      cidr_blocks = data.aws_vpc.selected.cidr_block
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH service"
      cidr_blocks = data.aws_vpc.selected.cidr_block
    }
  ]
}

# Create EC2 instances for consul cluster
module "ec2_consul" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "2.13.0"

  name                   = var.consul_instance_name
  instance_count         = length(local.consul_ips)
  ami                    = module.consul_ami.id
  instance_type          = var.consul_instance_type
  key_name               = aws_key_pair.keypair.key_name
  monitoring             = var.detailed_monitoring
  vpc_security_group_ids = [module.sg_consul.this_security_group_id]
  subnet_ids             = local.private_subnet_ids
  private_ips            = local.consul_ips
  tags                   = var.tags
}

# Create a security group for vault servers
module "sg_vault" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "3.10.0"

  name         = var.sg_vault_name
  description  = var.sg_vault_description
  vpc_id       = var.vpc_id
  egress_rules = ["all-all"]
  ingress_with_cidr_blocks = [
    {
      from_port   = var.vault_port
      to_port     = var.vault_port + 1
      protocol    = "tcp"
      description = "Vault ports"
      cidr_blocks = data.aws_vpc.selected.cidr_block
    },
    {
      from_port   = var.consul_port + 1
      to_port     = var.consul_port + 1
      protocol    = "tcp"
      description = "Vault ports"
      cidr_blocks = data.aws_vpc.selected.cidr_block
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH service"
      cidr_blocks = data.aws_vpc.selected.cidr_block
    }
  ]
}

# Create EC2 instances for consul cluster
module "ec2_vault" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "2.13.0"

  name                   = var.vault_instance_name
  instance_count         = length(local.vault_ips)
  ami                    = module.vault_ami.id
  instance_type          = var.vault_instance_type
  key_name               = aws_key_pair.keypair.key_name
  monitoring             = var.detailed_monitoring
  vpc_security_group_ids = [module.sg_vault.this_security_group_id]
  subnet_ids             = local.private_subnet_ids
  private_ips            = local.vault_ips
  tags                   = var.tags
}

# Create a security group for bastion host
module "sg_bastion" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "3.10.0"

  name         = var.sg_bastion_name
  description  = var.sg_bastion_description
  vpc_id       = var.vpc_id
  egress_rules = ["all-all"]
  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH service"
      cidr_blocks = var.bastion_ssh_cidr_block
    }
  ]
}

# Create an EC2 instance for bastion host
module "ec2_bastion" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "2.13.0"

  name                   = var.bastion_instance_name
  instance_count         = 1
  ami                    = module.bastion_ami.id
  instance_type          = var.bastion_instance_type
  key_name               = aws_key_pair.keypair.key_name
  monitoring             = var.detailed_monitoring
  vpc_security_group_ids = [module.sg_bastion.this_security_group_id]
  subnet_ids             = local.public_subnet_ids
  tags                   = var.tags
  user_data              = templatefile("${path.module}/bastion_setup.tpl", local.bastion_setup_vars)
}

resource "aws_key_pair" "keypair" {
  key_name_prefix = var.keypair_name_prefix
  public_key      = var.keypair_public
  tags            = var.tags
}
