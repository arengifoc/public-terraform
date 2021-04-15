# terraform {
#   backend "remote" {
#     hostname     = "app.terraform.io"
#     organization = "FAMRENCAR"

#     workspaces {
#       name = "azure-vms"
#     }
#   }
# }

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.location
}

locals {
  rg_name   = split("/", azurerm_resource_group.rg.id)[4]
}
