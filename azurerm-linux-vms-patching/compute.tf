data "azurerm_subnet" "selected" {
  name                 = module.network.subnet_names[0]
  virtual_network_name = module.network.vnet_name
  #   name                 = var.subnet_names[0]
  #   virtual_network_name = var.net_name
  resource_group_name = local.rg_name
}


module "vm_linux" {
  source             = "git::https://gitlab.com/arengifoc/terraform-azurerm-vm.git?ref=27baf4bbd5ee162c98cc4486cba54b2bb60b8138"
  vm_count           = 1
  vm_name            = var.vm_name
  resource_group     = local.rg_name
  subnet_id          = data.azurerm_subnet.selected.id
  size               = var.vm_size
  admin_username     = var.admin_username
  os_image_publisher = element(split(",", var.os), 0)
  os_image_offer     = element(split(",", var.os), 1)
  os_image_sku       = element(split(",", var.os), 2)
  ssh_public_key     = var.public_sshkey
  public_ip_type     = var.public_ip_type
  tags               = var.tags
  nsg_rules          = var.nsg_rules
}
