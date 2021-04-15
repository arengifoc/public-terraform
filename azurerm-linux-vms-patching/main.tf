terraform {
  backend "s3" {
    bucket = "aws-sandbox-org-tfstate"
    key    = "azurerm-linux-vms-patching/terraform.tfstate"
    region = "us-east-1"
  }
}


provider "azurerm" {
  features {}
}

locals {
  # If RG already exists
  # rg_name  = var.rg_name
  # If RG needs to be created
  rg_name  = split("/", azurerm_resource_group.this.id)[4]
  location = data.azurerm_resource_group.selected.location
}

data "azurerm_resource_group" "selected" {
  name = local.rg_name
}

resource "azurerm_resource_group" "this" {
  name     = var.rg_name
  location = var.location
  tags     = var.tags
}

output "rg_name" {
  value = local.rg_name
}

output "rg_location" {
  value = local.location
}

output "subnet_id" {
  value = data.azurerm_subnet.selected.id
}
