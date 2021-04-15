module "network" {
  source = "git::https://gitlab.com/arengifoc/terraform-azurerm-network.git?ref=v1.1.0"

  resource_group = local.rg_name
  vnet_name      = var.net_name
  vnet_cidr      = var.net_cidr
  subnet_names   = var.subnet_names
  subnet_cidrs   = var.subnet_cidrs
  tags           = var.tags
}
