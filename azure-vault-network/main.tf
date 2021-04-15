terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "FAMRENCAR"

    workspaces {
      name = "vault-azure-network"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "primary_rg" {
  name     = var.primary_rg_name
  location = var.primary_location
}

resource "azurerm_resource_group" "secondary_rg" {
  name     = var.secondary_rg_name
  location = var.secondary_location
}

module "primary_vnet" {
  source  = "Azure/network/azurerm"
  version = "3.1.1"

  vnet_name           = var.primary_vnet_name
  resource_group_name = split("/", azurerm_resource_group.primary_rg.id)[4]
  address_space       = var.primary_vnet_cidr
  subnet_prefixes     = [var.primary_subnet_cidr]
  subnet_names        = [var.primary_subnet_name]
  tags                = var.tags
}

module "secondary_vnet" {
  source  = "Azure/network/azurerm"
  version = "3.1.1"

  vnet_name           = var.secondary_vnet_name
  resource_group_name = split("/", azurerm_resource_group.secondary_rg.id)[4]
  address_space       = var.secondary_vnet_cidr
  subnet_prefixes     = [var.secondary_subnet_cidr]
  subnet_names        = [var.secondary_subnet_name]
  tags                = var.tags
}
