module "primary_vnet" {
  source = "../../../../terraform-azure-network/"

  vnet_name           = var.primary_vnet_name
  resource_group_name = azurerm_resource_group.primary_rg.name
  location            = azurerm_resource_group.primary_rg.location
  address_space       = var.primary_vnet_cidr
  subnet_prefixes     = [var.primary_subnet_cidr]
  subnet_names        = [var.primary_subnet_name]
  tags                = var.tags
}

# module "secondary_vnet" {
#   source = "../../../../terraform-azure-network/"

#   vnet_name           = var.secondary_vnet_name
#   resource_group_name = azurerm_resource_group.secondary_rg.name
#   location            = azurerm_resource_group.secondary_rg.location
#   address_space       = var.secondary_vnet_cidr
#   subnet_prefixes     = [var.secondary_subnet_cidr]
#   subnet_names        = [var.secondary_subnet_name]
#   tags                = var.tags
# }

locals {
  primary_subnets_names   = [for item in module.primary_vnet.vnet_subnets : element(split("/", item), length(split("/", item)) - 1)]
  # secondary_subnets_names = [for item in module.secondary_vnet.vnet_subnets : element(split("/", item), length(split("/", item)) - 1)]
}

