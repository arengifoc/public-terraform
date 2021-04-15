terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "FAMRENCAR"

    workspaces {
      name = "vault-cluster-company"
    }
  }
}

provider "aws" {
  alias  = "primary"
  region = var.primary_region
}

provider "aws" {
  alias  = "secondary"
  region = var.secondary_region
}

locals {
  primary_private_subnet_ids   = [for item in var.primary_network_settings : item.subnet_id if item.type == "private"]
  primary_public_subnet_ids    = [for item in var.primary_network_settings : item.subnet_id if item.type == "public"]
  primary_consul_ips           = flatten([for item in var.primary_network_settings : item.consul_ips if item.type == "private"])
  primary_vault_ips            = flatten([for item in var.primary_network_settings : item.vault_ips if item.type == "private"])
  secondary_private_subnet_ids = [for item in var.secondary_network_settings : item.subnet_id if item.type == "private"]
  secondary_public_subnet_ids  = [for item in var.secondary_network_settings : item.subnet_id if item.type == "public"]
  secondary_consul_ips         = flatten([for item in var.secondary_network_settings : item.consul_ips if item.type == "private"])
  secondary_vault_ips          = flatten([for item in var.secondary_network_settings : item.vault_ips if item.type == "private"])
}
