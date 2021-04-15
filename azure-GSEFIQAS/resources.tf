# Creacion de IPs publicas
resource "azurerm_public_ip" "PIP_GSEFIQAS" {
    name                = "PIP-${var.BASE_NAME}"
    location            = "${var.AZURE_LOCATION}"
    resource_group_name = "${var.AZURE_RG}"
    allocation_method   = "Static"
    tags {
      comments = "Created by Terraform"
    }
}

# Creacion de Network Security Groups
resource "azurerm_network_security_group" "NSG_GSEFIQAS" {
  name                = "NSG-${var.BASE_NAME}"
  location            = "${var.AZURE_LOCATION}"
  resource_group_name = "${var.AZURE_RG}"
    tags {
      comments = "Created by Terraform"
    }
}

# Crear reglas de trafico entrante
resource "azurerm_network_security_rule" "NSR_GSEFIQAS_SSH" {
  name                        = "SR_IN_SSH"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${var.AZURE_RG}"
  network_security_group_name = "${azurerm_network_security_group.NSG_GSEFIQAS.name}"
}

resource "azurerm_network_security_rule" "NSR_GSEFIQAS_SAP" {
  name                        = "SR_IN_SAP"
  priority                    = 200
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = ["3200","8000","44300"]
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${var.AZURE_RG}"
  network_security_group_name = "${azurerm_network_security_group.NSG_GSEFIQAS.name}"
}

# Creacion de dos interfaces de red
resource "azurerm_network_interface" "NIC_GSEFIQAS" {
    name                      = "NIC-${var.BASE_NAME}"
    location                  = "${var.AZURE_LOCATION}"
    resource_group_name       = "${var.AZURE_RG}"
    network_security_group_id = "${azurerm_network_security_group.NSG_GSEFIQAS.id}"
    ip_configuration {
        name                          = "ip-config"
        subnet_id                     = "${var.AZURE_SUBNET_ID}"
        private_ip_address_allocation = "Static"
        private_ip_address            = "${var.IPADDR}"
        public_ip_address_id          = "${azurerm_public_ip.PIP_GSEFIQAS.id}"
    }
  tags {
    comments = "Created by Terraform"
  }
}

# Creacion de una VM Linux
resource "azurerm_virtual_machine" "VM_GSEFIQAS" {
  # Nombre de la VM
  name = "${var.BASE_NAME}"

  # Tamanio de la VM
  vm_size = "${var.AZURE_VMSIZE}"

  # Ubicacion
  location = "${var.AZURE_LOCATION}"

  # Resource group dentro del cual crear la VM
  resource_group_name = "${var.AZURE_RG}"

  # Lista (con corchetes) de interfaces de red
  network_interface_ids = ["${azurerm_network_interface.NIC_GSEFIQAS.id}"]

  # Borrar el disco de SO al eliminar la VM
  delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = "${var.AZURE_VMIMAGE_PUBLISHER}"
    offer     = "${var.AZURE_VMIMAGE_OFFER}"
    sku       = "${var.AZURE_VMIMAGE_SKU}"
    version   = "latest"
  }

  # Caracteristicas del tipo de disco de SO
  storage_os_disk {
    name              = "DSK-rootfs-${var.BASE_NAME}"
    create_option     = "FromImage"
    managed_disk_type = "StandardSSD_LRS"
  }

  # Caracteristicas de los tipos de disco de data
  #storage_data_disk {
    #name              = "DSK-rootfs-${var.BASE_NAME}-2"
    #create_option     = "Empty"
    #disk_size_gb      = "50"
    #lun               = "0"
    #managed_disk_type = "StandardSSD_LRS"
  #}

  storage_data_disk {
    name              = "DSK-data-${var.BASE_NAME}-1"
    create_option     = "Empty"
    disk_size_gb      = "256"
    lun               = "0"
    managed_disk_type = "Premium_LRS"
  }

  storage_data_disk {
    name              = "DSK-data-${var.BASE_NAME}-2"
    create_option     = "Empty"
    disk_size_gb      = "256"
    lun               = "1"
    managed_disk_type = "Premium_LRS"
  }

  # Parametros de SO
  os_profile {
    computer_name  = "${var.BASE_NAME}"
    admin_username = "${var.OS_USER}"
    admin_password = "${var.OS_USER_PW}"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags {
    comments = "Created by Terraform"
  }
}
