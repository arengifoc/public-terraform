# Create a security group for primary consul servers
module "primary_sg_consul" {
  providers = {
    aws = aws.primary
  }
  source  = "terraform-aws-modules/security-group/aws"
  version = "3.10.0"

  name         = "primary_sg_consul"
  description  = "SG for consul nodes"
  vpc_id       = var.primary_vpc_id
  egress_rules = ["all-all"]
  ingress_with_cidr_blocks = [
    {
      from_port   = var.consul_port
      to_port     = var.consul_port + 2
      protocol    = "tcp"
      description = "Consul ports"
      cidr_blocks = data.aws_vpc.primary_selected.cidr_block
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH service"
      cidr_blocks = data.aws_vpc.primary_selected.cidr_block
    }
  ]
}

# Create EC2 instances for primary consul cluster
module "primary_consul_ec2_instances" {
  providers = {
    aws = aws.primary
  }
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "2.13.0"

  name                   = "consul"
  instance_count         = length(local.primary_consul_ips)
  ami                    = data.aws_ami.primary_selected.id
  instance_type          = var.primary_consul_instance_type
  key_name               = var.keypair
  monitoring             = false
  vpc_security_group_ids = [module.primary_sg_consul.this_security_group_id]
  subnet_ids             = local.primary_private_subnet_ids
  private_ips            = local.primary_consul_ips
  tags                   = var.tags
}

# Create a security group for primary vault servers
module "primary_sg_vault" {
  providers = {
    aws = aws.primary
  }
  source  = "terraform-aws-modules/security-group/aws"
  version = "3.10.0"

  name         = "primary_sg_vault"
  description  = "SG for vault nodes"
  vpc_id       = var.primary_vpc_id
  egress_rules = ["all-all"]
  ingress_with_cidr_blocks = [
    {
      from_port   = var.vault_port
      to_port     = var.vault_port + 1
      protocol    = "tcp"
      description = "Vault ports"
      cidr_blocks = data.aws_vpc.primary_selected.cidr_block
    },
    {
      from_port   = var.consul_port + 1
      to_port     = var.consul_port + 1
      protocol    = "tcp"
      description = "Vault ports"
      cidr_blocks = data.aws_vpc.primary_selected.cidr_block
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH service"
      cidr_blocks = data.aws_vpc.primary_selected.cidr_block
    }
  ]
}

# Create EC2 instances for primary vault cluster
module "primary_vault_ec2_instances" {
  providers = {
    aws = aws.primary
  }
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "2.13.0"

  name                   = "vault"
  instance_count         = length(local.primary_vault_ips)
  ami                    = data.aws_ami.primary_selected.id
  instance_type          = var.primary_vault_instance_type
  key_name               = var.keypair
  monitoring             = false
  vpc_security_group_ids = [module.primary_sg_vault.this_security_group_id]
  subnet_ids             = local.primary_private_subnet_ids
  private_ips            = local.primary_vault_ips
  tags                   = var.tags
}

# Create a security group for primary bastion host
module "primary_sg_bastion" {
  providers = {
    aws = aws.primary
  }
  source  = "terraform-aws-modules/security-group/aws"
  version = "3.10.0"

  name         = "primary_sg_bastion"
  description  = "SG for bastion host"
  vpc_id       = var.primary_vpc_id
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

# Create an EC2 instance for primary bastion host
module "primary_bastion_ec2_instance" {
  providers = {
    aws = aws.primary
  }
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "2.13.0"

  name                   = "bastion"
  instance_count         = 1
  ami                    = data.aws_ami.primary_selected.id
  instance_type          = var.bastion_instance_type
  key_name               = var.keypair
  monitoring             = false
  vpc_security_group_ids = [module.primary_sg_bastion.this_security_group_id]
  subnet_ids             = local.primary_public_subnet_ids
  tags                   = var.tags
}

# Create a security group for secondary consul servers
module "secondary_sg_consul" {
  providers = {
    aws = aws.secondary
  }
  source  = "terraform-aws-modules/security-group/aws"
  version = "3.10.0"

  create       = length(local.secondary_consul_ips) > 0 || var.secondary_vpc_id != null ? true : false
  name         = "secondary_sg_consul"
  description  = "SG for consul nodes"
  vpc_id       = var.secondary_vpc_id
  egress_rules = ["all-all"]
  ingress_with_cidr_blocks = [
    {
      from_port   = var.consul_port
      to_port     = var.consul_port + 2
      protocol    = "tcp"
      description = "Consul ports"
      cidr_blocks = data.aws_vpc.secondary_selected[0].cidr_block
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH service"
      cidr_blocks = data.aws_vpc.secondary_selected[0].cidr_block
    }
  ]
}

# Create EC2 instances for secondary consul cluster
module "secondary_consul_ec2_instances" {
  providers = {
    aws = aws.secondary
  }
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "2.13.0"

  instance_count         = length(local.secondary_consul_ips) > 0 || var.secondary_vpc_id != null ? length(local.secondary_consul_ips) : 0
  name                   = "consul"
  ami                    = data.aws_ami.secondary_selected.id
  instance_type          = var.secondary_consul_instance_type
  key_name               = var.keypair
  monitoring             = false
  vpc_security_group_ids = [module.secondary_sg_consul.this_security_group_id]
  subnet_ids             = length(local.secondary_private_subnet_ids) > 0 ? local.secondary_private_subnet_ids : []
  private_ips            = length(local.secondary_consul_ips) > 0 ? local.secondary_consul_ips : []
  tags                   = var.tags
}

# Create a security group for secondary vault servers
module "secondary_sg_vault" {
  providers = {
    aws = aws.secondary
  }
  source  = "terraform-aws-modules/security-group/aws"
  version = "3.10.0"

  create       = length(local.secondary_vault_ips) > 0 || var.secondary_vpc_id != null ? true : false
  name         = "secondary_sg_vault"
  description  = "SG for vault nodes"
  vpc_id       = var.secondary_vpc_id
  egress_rules = ["all-all"]
  ingress_with_cidr_blocks = [
    {
      from_port   = var.vault_port
      to_port     = var.vault_port + 1
      protocol    = "tcp"
      description = "Vault ports"
      cidr_blocks = data.aws_vpc.secondary_selected[0].cidr_block
    },
    {
      from_port   = var.consul_port + 1
      to_port     = var.consul_port + 1
      protocol    = "tcp"
      description = "Vault ports"
      cidr_blocks = data.aws_vpc.secondary_selected[0].cidr_block
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH service"
      cidr_blocks = data.aws_vpc.secondary_selected[0].cidr_block
    }
  ]
}

# Create EC2 instances for primary vault cluster
module "secondary_vault_ec2_instances" {
  providers = {
    aws = aws.secondary
  }
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "2.13.0"

  instance_count         = length(local.secondary_vault_ips) > 0 || var.secondary_vpc_id != null ? length(local.secondary_vault_ips) : 0
  name                   = "vault"
  ami                    = data.aws_ami.secondary_selected.id
  instance_type          = var.secondary_vault_instance_type
  key_name               = var.keypair
  monitoring             = false
  vpc_security_group_ids = [module.secondary_sg_vault.this_security_group_id]
  subnet_ids             = length(local.secondary_private_subnet_ids) > 0 ? local.secondary_private_subnet_ids : []
  private_ips            = length(local.secondary_vault_ips) > 0 ? local.secondary_vault_ips : []
  tags                   = var.tags
}

# Create a security group for secondary bastion host
module "secondary_sg_bastion" {
  providers = {
    aws = aws.secondary
  }
  source  = "terraform-aws-modules/security-group/aws"
  version = "3.10.0"

  create       = length(local.secondary_vault_ips) > 0 || var.secondary_vpc_id != null ? true : false
  name         = "secondary_sg_bastion"
  description  = "SG for bastion host"
  vpc_id       = var.secondary_vpc_id
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

# Create an EC2 instance for secondary bastion host
module "secondary_bastion_ec2_instance" {
  providers = {
    aws = aws.secondary
  }
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "2.13.0"

  instance_count         = length(local.secondary_vault_ips) > 0 || var.secondary_vpc_id != null ? 1 : 0
  name                   = "bastion"
  ami                    = data.aws_ami.secondary_selected.id
  instance_type          = var.bastion_instance_type
  key_name               = var.keypair
  monitoring             = false
  vpc_security_group_ids = [module.secondary_sg_bastion.this_security_group_id]
  subnet_ids             = length(local.secondary_public_subnet_ids) > 0 ? local.secondary_public_subnet_ids : []
  tags                   = var.tags
}
