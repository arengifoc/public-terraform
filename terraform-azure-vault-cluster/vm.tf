# Create EC2 instances for consul cluster
module "consul" {
  source = "../terraform-azure-vm/"

  vm_count           = length(var.consul_ips)
  vm_name            = var.consul_vm_name
  resource_group     = var.resource_group
  vnet               = var.vnet
  subnet             = var.consul_subnet
  size               = var.consul_vm_size
  admin_username     = var.admin_username
  ssh_public_key     = var.ssh_public_data_key
  os_image_publisher = var.consul_os_publisher
  os_image_offer     = var.consul_os_offer
  os_image_sku       = var.consul_os_sku
  private_ips        = var.consul_ips
  azs                = var.consul_azs
  tags               = var.tags

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

# Create EC2 instances for vault cluster
module "vault" {
  source = "../terraform-azure-vm/"

  vm_count           = length(var.vault_ips)
  vm_name            = var.vault_vm_name
  resource_group     = var.resource_group
  vnet               = var.vnet
  subnet             = var.vault_subnet
  size               = var.vault_vm_size
  admin_username     = var.admin_username
  ssh_public_key     = var.ssh_public_data_key
  os_image_publisher = var.vault_os_publisher
  os_image_offer     = var.vault_os_offer
  os_image_sku       = var.vault_os_sku
  private_ips        = var.vault_ips
  azs                = var.vault_azs
  tags               = var.tags

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

# Create an EC2 instance for bastion host
module "bastion" {
  source = "../terraform-azure-vm/"

  vm_count           = 1
  vm_name            = var.bastion_vm_name
  resource_group     = var.resource_group
  vnet               = var.vnet
  subnet             = var.bastion_subnet
  size               = var.bastion_vm_size
  admin_username     = var.admin_username
  ssh_public_key     = var.ssh_public_data_key
  os_image_publisher = var.bastion_os_publisher
  os_image_offer     = var.bastion_os_offer
  os_image_sku       = var.bastion_os_sku
  public_ip_type     = var.bastion_public_ip_type
  custom_data        = templatefile("${path.module}/bastion_setup.tpl", local.bastion_setup_vars)
  tags               = var.tags

  nsg_rules = [
    {
      name                       = "in_ssh"
      description                = "Allow incoming SSH traffic"
      protocol                   = "tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = var.bastion_ssh_cidr_block
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
