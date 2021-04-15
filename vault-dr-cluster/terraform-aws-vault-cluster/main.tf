module "consul_ami" {
  source  = "app.terraform.io/FAMRENCAR/data-amis/aws"
  version = "1.1.0"

  os = var.consul_os
}

module "vault_ami" {
  source = "app.terraform.io/FAMRENCAR/data-amis/aws"

  os = var.vault_os
}

module "bastion_ami" {
  source  = "app.terraform.io/FAMRENCAR/data-amis/aws"
  version = "1.1.0"

  os = var.bastion_os
}

locals {
  private_subnet_ids = [for item in var.network_settings : item.subnet_id if item.type == "private"]
  public_subnet_ids  = [for item in var.network_settings : item.subnet_id if item.type == "public"]
  consul_ips         = flatten([for item in var.network_settings : item.consul_ips if item.type == "private"])
  vault_ips          = flatten([for item in var.network_settings : item.vault_ips if item.type == "private"])
  bastion_setup_vars = {
    privkey              = var.keypair_private
    vault_instance_name  = var.vault_instance_name
    consul_instance_name = var.consul_instance_name
    consul_ips           = local.consul_ips
    vault_ips            = local.vault_ips
    consul_ssh_user      = module.consul_ami.default_user
    vault_ssh_user       = module.vault_ami.default_user
    bastion_ssh_user     = module.bastion_ami.default_user
    ca_cert_file         = var.ca_cert_file
    server_cert_file     = var.server_cert_file
    server_key_file      = var.server_key_file
    consul_vars = merge(var.consul_vars, {
      consul_port = var.consul_port
    })
    vault_vars = merge(var.vault_vars, {
      aws_access_key = var.create_kms_key == true ? aws_iam_access_key.iam_access_key[0].id : ""
      aws_kms_key_id = var.create_kms_key == true ? aws_kms_key.vault_key[0].id : ""
      aws_region     = var.create_kms_key == true ? data.aws_region.current.name : ""
      aws_secret_key = var.create_kms_key == true ? aws_iam_access_key.iam_access_key[0].secret : ""
      vault_port     = var.vault_port
      vault_storage  = length(local.consul_ips) > 0 ? "consul" : "raft"
    })
  }
}

data "aws_vpc" "selected" {
  id = var.vpc_id
}

data "aws_region" "current" {
}
