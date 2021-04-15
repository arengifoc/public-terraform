provider "azurerm" {
  features {}
}

module "postgres" {
  source = "Azure/postgresql/azurerm"

  resource_group_name          = var.rg_name
  location                     = data.azurerm_resource_group.selected.location
  server_name                  = var.postgres-server-name
  sku_name                     = var.postgres-sku
  storage_mb                   = 5120
  backup_retention_days        = 7
  geo_redundant_backup_enabled = false
  administrator_login          = var.postgres-admin-username
  administrator_password       = var.postgres-admin-password
  server_version               = var.postgres-engine-version
  ssl_enforcement_enabled      = true
  db_names                     = var.postgres-dbs
  db_charset                   = "UTF8"
  db_collation                 = "English_United States.1252"
  tags                         = var.tags

  firewall_rule_prefix = "firewall-"
  firewall_rules = [
    {
      name     = "tfe",
      start_ip = "0.0.0.0",
      end_ip   = "0.0.0.0"
    }
  ]

  postgresql_configurations = {
    backslash_quote = "on",
  }
}

data "azurerm_resource_group" "selected" {
  name = var.rg_name
}
