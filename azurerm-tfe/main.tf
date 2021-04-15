provider "azurerm" {
  features {}
}


locals {
  template_vars = {
    tlsbootstraphostname = "tfe4.company.global"
    sas_token            = "?sv=2019-12-12&ss=b&srt=sco&sp=rlx&se=2020-11-19T22:24:33Z&st=2020-11-19T14:24:33Z&spr=https&sig=R6mCAUIijlhVzu2qs1JoYywSh%2B9BGnTFhKnW4%2Fb39FA%3D"
    pg_netloc            = "terraformbd.postgres.database.azure.com"
    pg_password          = "Terraform2020.."
    pg_user              = "adminterraform@terraformbd"
    pg_dbname            = "ptfe1"
    custom_image_tag     = "arengifoc/tfeimage"
  }

}

data "azurerm_resource_group" "selected" {
  name = var.rg_name
}

data "azurerm_subnet" "selected" {
  name                 = var.subnet_name
  virtual_network_name = var.net_name
  resource_group_name  = var.rg_name
}

# module "vm_tfe_1" {
#   source         = "git::https://gitlab.com/arengifoc/terraform-azurerm-vm.git?ref=72d13ecbcc7a74286680a17056ea0702201eeb65"
#   vm_count       = 1
#   vm_name        = var.vm_name
#   resource_group = var.rg_name
#   subnet_id      = data.azurerm_subnet.selected.id
#   size           = var.vm_size
#   admin_username = var.admin_username
#   ssh_public_key = var.public_sshkey
#   os_image_id    = var.vm_imageid
#   public_ip_type = var.public_ip_type
#   tags           = var.tags
#   custom_data = base64encode(
#     templatefile(
#       "${path.module}/${var.custom_data_template}",
#       local.template_vars
#     )
#   )
#   nsg_rules = var.nsg_rules
# }

resource "azurerm_network_security_group" "sg" {
  name                = "nsg_${var.vm_name}"
  location            = data.azurerm_resource_group.selected.location
  resource_group_name = var.rg_name
}

resource "azurerm_network_security_rule" "sg_rule" {
  count                       = length(var.nsg_rules)
  name                        = lookup(var.nsg_rules[count.index], "name", "rule-${count.index}")
  priority                    = lookup(var.nsg_rules[count.index], "priority", 100 + count.index)
  direction                   = lookup(var.nsg_rules[count.index], "direction", "Inbound")
  access                      = lookup(var.nsg_rules[count.index], "access", "Allow")
  protocol                    = lookup(var.nsg_rules[count.index], "protocol", "*")
  destination_port_range      = lookup(var.nsg_rules[count.index], "dst_port", "*")
  source_port_range           = lookup(var.nsg_rules[count.index], "src_port", "*")
  source_address_prefix       = lookup(var.nsg_rules[count.index], "src_addr", "*")
  destination_address_prefix  = lookup(var.nsg_rules[count.index], "dst_addr", "*")
  resource_group_name         = var.rg_name
  network_security_group_name = azurerm_network_security_group.sg.name
}

resource "azurerm_linux_virtual_machine_scale_set" "tfe" {
  name                = "ss-tfe"
  resource_group_name = var.rg_name
  location            = data.azurerm_resource_group.selected.location
  sku                 = var.vm_size
  instances           = 1
  admin_username      = var.admin_username
  tags                = var.tags
  source_image_id     = var.vm_imageid

  custom_data = base64encode(
    templatefile(
      "${path.module}/${var.custom_data_template}",
      local.template_vars
    )
  )

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.public_sshkey
  }

  os_disk {
    storage_account_type = var.disk_type
    caching              = "ReadWrite"
  }

  network_interface {
    name                      = "ip_${var.vm_name}"
    primary                   = true
    network_security_group_id = azurerm_network_security_group.sg.id

    ip_configuration {
      name      = "internal"
      primary   = true
      subnet_id = data.azurerm_subnet.selected.id
      public_ip_address {
        name = "pip_${var.vm_name}"
      }
    }
  }
}
