# Creacion del RG
resource "azurerm_resource_group" "RG01" {
  name     = "${var.PREFIX}-${var.AZURE_RG}"
  location = "${var.AZURE_LOCATION}"
  tags     = "${var.AZURE_TAGS}"
}

# Creacion de la VNET y subnet
resource "azurerm_virtual_network" "VNET01" {
  name                = "${var.PREFIX}-VNET01"
  address_space       = ["10.20.30.0/23"]
  location            = "${var.AZURE_LOCATION}"
  resource_group_name = "${azurerm_resource_group.RG01.name}"
  tags                = "${var.AZURE_TAGS}"
}

resource "azurerm_subnet" "SUBNET01" {
  name                 = "${var.PREFIX}-SUBNET01"
  resource_group_name  = "${azurerm_resource_group.RG01.name}"
  virtual_network_name = "${azurerm_virtual_network.VNET01.name}"
  address_prefix       = "10.20.30.0/24"
}

# Creacion de IPs publicas
resource "azurerm_public_ip" "PIP01" {
    name                = "${var.PREFIX}-PIP-${var.BASE_NAME1}"
    location            = "${var.AZURE_LOCATION}"
    resource_group_name = "${azurerm_resource_group.RG01.name}"
    allocation_method   = "Dynamic"
    tags                = "${var.AZURE_TAGS}"
}

resource "azurerm_public_ip" "PIP02" {
    name                = "${var.PREFIX}-PIP-${var.BASE_NAME2}"
    location            = "${var.AZURE_LOCATION}"
    resource_group_name = "${azurerm_resource_group.RG01.name}"
    allocation_method   = "Dynamic"
    tags                = "${var.AZURE_TAGS}"
}

# Creacion de Network Security Groups
resource "azurerm_network_security_group" "NSG01" {
  name                = "${var.PREFIX}-NSG-${var.BASE_NAME1}"
  location            = "${var.AZURE_LOCATION}"
  resource_group_name = "${azurerm_resource_group.RG01.name}"
  tags                = "${var.AZURE_TAGS}"
}

resource "azurerm_network_security_group" "NSG02" {
  name                = "${var.PREFIX}-NSG-${var.BASE_NAME2}"
  location            = "${var.AZURE_LOCATION}"
  resource_group_name = "${azurerm_resource_group.RG01.name}"
  tags                = "${var.AZURE_TAGS}"
}

# Reglas de seguridad para los Network Security Groups
resource "azurerm_network_security_rule" "NSR01" {
  name                        = "${var.PREFIX}-SR_IN_SSH"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${azurerm_resource_group.RG01.name}"
  network_security_group_name = "${azurerm_network_security_group.NSG01.name}"
}

resource "azurerm_network_security_rule" "NSR02" {
  name                        = "${var.PREFIX}-SR_IN_RDP"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${azurerm_resource_group.RG01.name}"
  network_security_group_name = "${azurerm_network_security_group.NSG02.name}"
}

# Creacion de dos interfaces de red
resource "azurerm_network_interface" "NIC01" {
  name                      = "${var.PREFIX}-NIC-${var.BASE_NAME1}"
  location                  = "${var.AZURE_LOCATION}"
  resource_group_name       = "${azurerm_resource_group.RG01.name}"
  network_security_group_id = "${azurerm_network_security_group.NSG01.id}"
  ip_configuration {
    name                          = "ip-config"
    subnet_id                     = "${azurerm_subnet.SUBNET01.id}"
    private_ip_address_allocation = "Static"
    private_ip_address            = "${var.IPADDR1}"
    public_ip_address_id          = "${azurerm_public_ip.PIP01.id}"
  }
  resource_group_name       = "${azurerm_resource_group.RG01.name}"
}

resource "azurerm_network_interface" "NIC02" {
  name                      = "${var.PREFIX}-NIC-${var.BASE_NAME2}"
  location                  = "${var.AZURE_LOCATION}"
  resource_group_name       = "${azurerm_resource_group.RG01.name}"
  network_security_group_id = "${azurerm_network_security_group.NSG02.id}"
  ip_configuration {
    name                          = "ip-config"
    subnet_id                     = "${azurerm_subnet.SUBNET01.id}"
    private_ip_address_allocation = "Static"
    private_ip_address            = "${var.IPADDR2}"
    public_ip_address_id          = "${azurerm_public_ip.PIP02.id}"
  }
  resource_group_name       = "${azurerm_resource_group.RG01.name}"
}

# Creacion de Storage Account y container para los discos
resource "azurerm_storage_account" "stgacc01" {
  name                     = "companycloudteststgacc01"
  resource_group_name      = "${azurerm_resource_group.RG01.name}"
  location                 = "${var.AZURE_LOCATION}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = "${var.AZURE_TAGS}"
}

resource "azurerm_storage_container" "CONTAINER01" {
  name                  = "vhds"
  resource_group_name   = "${azurerm_resource_group.RG01.name}"
  storage_account_name  = "${azurerm_storage_account.stgacc01.name}"
  container_access_type = "private"
}

# Creacion de dos VMs: una linux y una windows
resource "azurerm_virtual_machine" "VM01" {
  name                             = "${var.PREFIX}-vm-${var.BASE_NAME1}"
  vm_size                          = "${var.AZURE_VMSIZE}"
  location                         = "${var.AZURE_LOCATION}"
  resource_group_name              = "${azurerm_resource_group.RG01.name}"
  network_interface_ids            = ["${azurerm_network_interface.NIC01.id}"]
  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true
  storage_image_reference {
    publisher = "${var.AZURE_VMIMAGE_PUBLISHER1}"
    offer     = "${var.AZURE_VMIMAGE_OFFER1}"
    sku       = "${var.AZURE_VMIMAGE_SKU1}"
    version   = "latest"
  }
  storage_os_disk {
    name              = "DSK-rootfs-${var.BASE_NAME1}"
    create_option     = "FromImage"
    # Solo valido para discos unmanaged
    vhd_uri           = "${azurerm_storage_account.stgacc01.primary_blob_endpoint}${azurerm_storage_container.CONTAINER01.name}/DSK-rootfs-${var.BASE_NAME1}.vhd"
  }
  storage_data_disk {
    name              = "DSK-data-${var.BASE_NAME1}-1"
    create_option     = "Empty"
    disk_size_gb      = "25"
    lun               = "0"
    # Solo valido para discos unmanaged
    vhd_uri           = "${azurerm_storage_account.stgacc01.primary_blob_endpoint}${azurerm_storage_container.CONTAINER01.name}/DSK-data-${var.BASE_NAME1}-1.vhd"
  }
  os_profile {
    computer_name  = "${var.BASE_NAME1}"
    admin_username = "${var.OS_USER}"
    admin_password = "${var.OS_USER_PW}"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
}

resource "azurerm_virtual_machine" "VM02" {
  name                             = "${var.PREFIX}-vm-${var.BASE_NAME2}"
  vm_size                          = "${var.AZURE_VMSIZE}"
  location                         = "${var.AZURE_LOCATION}"
  resource_group_name              = "${azurerm_resource_group.RG01.name}"
  network_interface_ids            = ["${azurerm_network_interface.NIC02.id}"]
  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true
  storage_image_reference {
    publisher = "${var.AZURE_VMIMAGE_PUBLISHER2}"
    offer     = "${var.AZURE_VMIMAGE_OFFER2}"
    sku       = "${var.AZURE_VMIMAGE_SKU2}"
    version   = "latest"
  }
  storage_os_disk {
    name              = "DSK-rootfs-${var.BASE_NAME2}"
    create_option     = "FromImage"
    # Solo valido para discos unmanaged
    vhd_uri           = "${azurerm_storage_account.stgacc01.primary_blob_endpoint}${azurerm_storage_container.CONTAINER01.name}/DSK-rootfs-${var.BASE_NAME2}.vhd"
  }
  storage_data_disk {
    name              = "DSK-data-${var.BASE_NAME2}-1"
    create_option     = "Empty"
    disk_size_gb      = "25"
    lun               = "0"
    # Solo valido para discos unmanaged
    vhd_uri           = "${azurerm_storage_account.stgacc01.primary_blob_endpoint}${azurerm_storage_container.CONTAINER01.name}/DSK-data-${var.BASE_NAME2}-1.vhd"
  }
  os_profile {
    computer_name  = "${var.BASE_NAME2}"
    admin_username = "${var.OS_USER}"
    admin_password = "${var.OS_USER_PW}"
  }
  os_profile_windows_config {
    provision_vm_agent = true
    timezone = "SA Pacific Standard Time"
  }
}
