resource "azurerm_user_assigned_identity" "identity" {
  resource_group_name = azurerm_resource_group.primary_rg.name
  location            = var.primary_location
  name                = "manage-backups"
}

# # Create EC2 instances for vault cluster
module "primary_vault" {
  source = "../../../../terraform-azure-vm/"

  vm_count                = 3
  vm_name                 = "vault-pri"
  resource_group          = azurerm_resource_group.primary_rg.name
  location                = azurerm_resource_group.primary_rg.location
  vnet                    = module.primary_vnet.vnet_name
  subnet                  = local.primary_subnets_names[0]
  size                    = "Standard_B1ms"
  admin_username          = "arengifo"
  ssh_public_key          = "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAymNMTOWQUIDm/LK0oIUQv0iTqUA/gwUWqWcA4CCu7PDa7vkAb3E2cGVwc3eBmTKT+v02rDU4fTqfhzGNzCPnCg7QIJqvQk+YsueaCLcUwww0zBQvBP0gJmhUSxT5aYyYgCPn0IH/OzhN5y3CpTfmODokjcKs5oWHruluIfyIrbcJC7rd+avJtD9HdGlHtVtz0cbQ3+clcpOAxIhK1LcXzoZKEBuG20lX1I27jSpVmXxzW3IEB0e1itPiaCMWeGyg+CwelKZIs3MsDTy3RPBqt1tWRZtHC4fR9G9s4/f0AGeX8jTgXviU8SsabH2Lvg4e4hdYImuibjA9YOeioy8U+w=="
  os_image_publisher      = "Canonical"
  os_image_offer          = "UbuntuServer"
  os_image_sku            = "18.04-LTS"
  private_ips             = ["172.23.1.21", "172.23.1.22", "172.23.1.23"]
  azs                     = ["1", "2", "3"]
  managed_user_identities = [azurerm_user_assigned_identity.identity.id]
  tags                    = var.tags

  nsg_rules = [
    {
      name                       = "in_ssh"
      description                = "Allow incoming SSH traffic"
      protocol                   = "tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "172.23.1.0/24"
      destination_address_prefix = "*"
      access                     = "allow"
      priority                   = 100
      direction                  = "Inbound"
    },
    {
      name                       = "in_vault"
      description                = "Allow incoming Vault traffic"
      protocol                   = "tcp"
      source_port_range          = "*"
      destination_port_range     = "8200-8201"
      source_address_prefix      = "172.23.1.0/24"
      destination_address_prefix = "*"
      access                     = "allow"
      priority                   = 101
      direction                  = "Inbound"
    },
    {
      name                       = "out_all"
      description                = "Allow all outgoing traffic"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
      access                     = "allow"
      priority                   = 4096
      direction                  = "Outbound"
    }
  ]
}

module "primary_bastion" {
  source = "../../../../terraform-azure-vm/"

  vm_count           = 1
  vm_name            = "bastion-pri"
  resource_group     = azurerm_resource_group.primary_rg.name
  location           = azurerm_resource_group.primary_rg.location
  vnet               = module.primary_vnet.vnet_name
  subnet             = local.primary_subnets_names[0]
  size               = "Standard_B1ms"
  admin_username     = "arengifo"
  ssh_public_key     = "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAymNMTOWQUIDm/LK0oIUQv0iTqUA/gwUWqWcA4CCu7PDa7vkAb3E2cGVwc3eBmTKT+v02rDU4fTqfhzGNzCPnCg7QIJqvQk+YsueaCLcUwww0zBQvBP0gJmhUSxT5aYyYgCPn0IH/OzhN5y3CpTfmODokjcKs5oWHruluIfyIrbcJC7rd+avJtD9HdGlHtVtz0cbQ3+clcpOAxIhK1LcXzoZKEBuG20lX1I27jSpVmXxzW3IEB0e1itPiaCMWeGyg+CwelKZIs3MsDTy3RPBqt1tWRZtHC4fR9G9s4/f0AGeX8jTgXviU8SsabH2Lvg4e4hdYImuibjA9YOeioy8U+w=="
  os_image_publisher = "Canonical"
  os_image_offer     = "UbuntuServer"
  os_image_sku       = "18.04-LTS"
  private_ips        = ["172.23.1.99"]
  public_ip_type     = "Dynamic"
  tags               = var.tags
  custom_data = base64encode(<<EOF
#!/bin/bash
apt-get update
apt-get install -y software-properties-common git tmux python3-jinja2
apt-add-repository --yes --update ppa:ansible/ansible
apt-get install -y ansible
EOF
  )

  nsg_rules = [
    {
      name                       = "in_ssh"
      description                = "Allow incoming SSH traffic"
      protocol                   = "tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
      access                     = "allow"
      priority                   = 100
      direction                  = "Inbound"
    },
    {
      name                       = "out_all"
      description                = "Allow all outgoing traffic"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
      access                     = "allow"
      priority                   = 4096
      direction                  = "Outbound"
    }
  ]
}

# module "secondary_vault" {
#   source = "../../../../terraform-azure-vm/"

#   vm_count           = 3
#   vm_name            = "vault-sec"
#   resource_group     = azurerm_resource_group.secondary_rg.name
#   location           = azurerm_resource_group.secondary_rg.location
#   vnet               = module.secondary_vnet.vnet_name
#   subnet             = local.secondary_subnets_names[0]
#   size               = "Standard_B1ms"
#   admin_username     = "arengifo"
#   ssh_public_key     = "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAymNMTOWQUIDm/LK0oIUQv0iTqUA/gwUWqWcA4CCu7PDa7vkAb3E2cGVwc3eBmTKT+v02rDU4fTqfhzGNzCPnCg7QIJqvQk+YsueaCLcUwww0zBQvBP0gJmhUSxT5aYyYgCPn0IH/OzhN5y3CpTfmODokjcKs5oWHruluIfyIrbcJC7rd+avJtD9HdGlHtVtz0cbQ3+clcpOAxIhK1LcXzoZKEBuG20lX1I27jSpVmXxzW3IEB0e1itPiaCMWeGyg+CwelKZIs3MsDTy3RPBqt1tWRZtHC4fR9G9s4/f0AGeX8jTgXviU8SsabH2Lvg4e4hdYImuibjA9YOeioy8U+w=="
#   os_image_publisher = "Canonical"
#   os_image_offer     = "UbuntuServer"
#   os_image_sku       = "18.04-LTS"
#   private_ips        = ["172.24.1.21", "172.24.1.22", "172.24.1.23"]
#   azs                = ["1", "2", "3"]
#   tags               = var.tags

#   nsg_rules = [
#     {
#       name                       = "in_ssh"
#       description                = "Allow incoming SSH traffic"
#       protocol                   = "tcp"
#       source_port_range          = "*"
#       destination_port_range     = "22"
#       source_address_prefix      = "172.24.1.0/24"
#       destination_address_prefix = "*"
#       access                     = "allow"
#       priority                   = 100
#       direction                  = "Inbound"
#     },
#     {
#       name                       = "in_vault"
#       description                = "Allow incoming Vault traffic"
#       protocol                   = "tcp"
#       source_port_range          = "*"
#       destination_port_range     = "8200-8201"
#       source_address_prefix      = "172.24.1.0/24"
#       destination_address_prefix = "*"
#       access                     = "allow"
#       priority                   = 101
#       direction                  = "Inbound"
#     },
#     {
#       name                       = "out_all"
#       description                = "Allow all outgoing traffic"
#       protocol                   = "*"
#       source_port_range          = "*"
#       destination_port_range     = "*"
#       source_address_prefix      = "*"
#       destination_address_prefix = "*"
#       access                     = "allow"
#       priority                   = 4096
#       direction                  = "Outbound"
#     }
#   ]
# }

# module "secondary_bastion" {
#   source = "../../../../terraform-azure-vm/"

#   vm_count           = 1
#   vm_name            = "bastion-sec"
#   resource_group     = azurerm_resource_group.secondary_rg.name
#   location           = azurerm_resource_group.secondary_rg.location
#   vnet               = module.secondary_vnet.vnet_name
#   subnet             = local.secondary_subnets_names[0]
#   size               = "Standard_B1ms"
#   admin_username     = "arengifo"
#   ssh_public_key     = "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAymNMTOWQUIDm/LK0oIUQv0iTqUA/gwUWqWcA4CCu7PDa7vkAb3E2cGVwc3eBmTKT+v02rDU4fTqfhzGNzCPnCg7QIJqvQk+YsueaCLcUwww0zBQvBP0gJmhUSxT5aYyYgCPn0IH/OzhN5y3CpTfmODokjcKs5oWHruluIfyIrbcJC7rd+avJtD9HdGlHtVtz0cbQ3+clcpOAxIhK1LcXzoZKEBuG20lX1I27jSpVmXxzW3IEB0e1itPiaCMWeGyg+CwelKZIs3MsDTy3RPBqt1tWRZtHC4fR9G9s4/f0AGeX8jTgXviU8SsabH2Lvg4e4hdYImuibjA9YOeioy8U+w=="
#   os_image_publisher = "Canonical"
#   os_image_offer     = "UbuntuServer"
#   os_image_sku       = "18.04-LTS"
#   private_ips        = ["172.24.1.99"]
#   public_ip_type     = "Dynamic"
#   tags               = var.tags
#   custom_data = base64encode(<<EOF
# #!/bin/bash
# apt-get update
# apt-get install -y software-properties-common git tmux python3-jinja2
# apt-add-repository --yes --update ppa:ansible/ansible
# apt-get install -y ansible
# EOF
#   )

#   nsg_rules = [
#     {
#       name                       = "in_ssh"
#       description                = "Allow incoming SSH traffic"
#       protocol                   = "tcp"
#       source_port_range          = "*"
#       destination_port_range     = "22"
#       source_address_prefix      = "*"
#       destination_address_prefix = "*"
#       access                     = "allow"
#       priority                   = 100
#       direction                  = "Inbound"
#     },
#     {
#       name                       = "out_all"
#       description                = "Allow all outgoing traffic"
#       protocol                   = "*"
#       source_port_range          = "*"
#       destination_port_range     = "*"
#       source_address_prefix      = "*"
#       destination_address_prefix = "*"
#       access                     = "allow"
#       priority                   = 4096
#       direction                  = "Outbound"
#     }
#   ]
# }
