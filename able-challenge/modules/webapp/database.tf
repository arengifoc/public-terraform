module "sg_rds" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "3.16.0"

  name         = "${var.name_prefix}-sg-rds"
  description  = "SG for RDS instance"
  vpc_id       = module.network.vpc_id
  egress_rules = ["all-all"]
  ingress_with_cidr_blocks = [
    {
      from_port   = var.port
      to_port     = var.port
      protocol    = "tcp"
      description = "${var.engine} service"
      cidr_blocks = module.network.vpc_cidr_block
    }
  ]
}

module "rds" {
  source  = "terraform-aws-modules/rds/aws"
  version = "2.20.0"

  identifier              = var.db_identifier
  engine                  = var.engine
  engine_version          = var.engine_version
  family                  = var.engine_family
  major_engine_version    = var.engine_major_version
  instance_class          = var.instance_size
  allocated_storage       = var.disk_size
  storage_encrypted       = false
  name                    = var.db_name
  username                = var.master_username
  password                = var.master_password
  port                    = var.port
  vpc_security_group_ids  = [module.sg_rds.this_security_group_id]
  maintenance_window      = var.maintenance_window
  backup_window           = var.backup_window
  backup_retention_period = var.backup_retention
  subnet_ids              = module.network.private_subnets
  deletion_protection     = false
  tags                    = var.tags
}

