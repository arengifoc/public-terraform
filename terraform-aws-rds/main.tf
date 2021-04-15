data "aws_subnet" "selected" {
  id = var.subnet_ids[0]
}

data "aws_vpc" "selected" {
  id = data.aws_subnet.selected.vpc_id
}

module "sg_rds" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "3.13.0"

  name         = "sg_rds"
  description  = "SG for RDS instance"
  vpc_id       = data.aws_subnet.selected.vpc_id
  egress_rules = ["all-all"]
  ingress_with_cidr_blocks = [
    {
      from_port   = var.port == null ? lookup(var.default_ports, var.engine, "mysql") : var.port
      to_port     = var.port == null ? lookup(var.default_ports, var.engine, "mysql") : var.port
      protocol    = "tcp"
      description = "${var.engine} service"
      cidr_blocks = var.allowed_cidr_block == null ? data.aws_vpc.selected.cidr_block : var.allowed_cidr_block
    }
  ]
}

module "rds" {
  source  = "terraform-aws-modules/rds/aws"
  version = "2.17.0"

  identifier              = var.identifier
  engine                  = var.engine
  engine_version          = var.engine_version == null ? lookup(var.default_engine_versions, var.engine, "mysql") : var.engine_version
  family                  = var.engine_family == null ? lookup(var.default_engine_families, var.engine, "mysql") : var.engine_family
  major_engine_version    = var.engine_major_version == null ? lookup(var.default_engine_major_versions, var.engine, "mysql") : var.engine_major_version
  instance_class          = var.instance_size
  allocated_storage       = var.disk_size
  storage_encrypted       = false
  name                    = var.dbname
  username                = var.master_username
  password                = var.master_password
  port                    = var.port == null ? lookup(var.default_ports, var.engine, "mysql") : var.port
  vpc_security_group_ids  = [module.sg_rds.this_security_group_id]
  maintenance_window      = var.maintenance_window
  backup_window           = var.backup_window
  backup_retention_period = var.backup_retention
  subnet_ids              = var.subnet_ids
  deletion_protection     = false
  tags                    = var.tags
}
