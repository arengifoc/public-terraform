module "network" {
  source = "git::https://gitlab.com/arengifoc/terraform-azurerm-network.git?ref=73ccb05e75246835d2849f6506c4143887137273"

  resource_group = local.rg_name
  vnet_name      = var.vnet_name
  vnet_cidr      = var.vnet_cidr
  subnet_names   = var.subnet_names
  subnet_cidrs   = var.subnet_cidrs
  tags           = var.tags
}
