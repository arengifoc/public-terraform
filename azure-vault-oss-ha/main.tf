# terraform {
#   backend "remote" {
#     hostname     = "app.terraform.io"
#     organization = "FAMRENCAR"

#     workspaces {
#       name = "vault-oss-ha"
#     }
#   }
# }

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "primary_rg" {
  name     = var.primary_rg_name
  location = var.primary_location
}

# resource "azurerm_resource_group" "secondary_rg" {
#   name     = var.secondary_rg_name
#   location = var.secondary_location
# }

# resource "azurerm_storage_account" "storage" {
#   name                     = "vaultossbackupstorage"
#   resource_group_name      = split("/", azurerm_resource_group.secondary_rg.id)[4]
#   location                 = var.secondary_location
#   account_tier             = "Standard"
#   account_replication_type = "LRS"
# }

# resource "azurerm_storage_container" "container" {
#   name                  = "backups"
#   storage_account_name  = azurerm_storage_account.storage.name
#   container_access_type = "private"
# }