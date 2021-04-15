# Creacion de un Resource Group
resource "azurerm_resource_group" "RG_1" {
    name     = "RG_test"
    location = "${var.AZURE_LOCATION}"
}

# Creacion de un Virtual Network
resource "azurerm_virtual_network" "VNET_1" {
    name                = "vnet01"
    address_space       = ["10.143.0.0/16"]
    location            = "${var.AZURE_LOCATION}"
    resource_group_name = "${azurerm_resource_group.RG_1.name}"
}

# Creacion de un Subnet
resource "azurerm_subnet" "SN_test1" {
    name                 = "SN_test1"
    resource_group_name  = "${azurerm_resource_group.RG_1.name}"
    virtual_network_name = "${azurerm_virtual_network.VNET_1.name}"
    address_prefix       = "10.143.2.0/24"
}

# Creacion de dos IPs publicas dinamicas
resource "azurerm_public_ip" "PIP_1" {
    name                = "PIP_lnxprueba01"
    location            = "${var.AZURE_LOCATION}"
    resource_group_name = "${azurerm_resource_group.RG_1.name}"
    allocation_method   = "Dynamic"
}

# Creacion de Network Security Groups
resource "azurerm_network_security_group" "NSG_1" {
  name                = "NSG_lnxprueba01"
  location            = "${var.AZURE_LOCATION}"
  resource_group_name = "${azurerm_resource_group.RG_1.name}"
}

# Crear una regla que permita conexiones SSH entrantes
resource "azurerm_network_security_rule" "NSR_1" {
  name                        = "SR_IN_SSH"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${azurerm_resource_group.RG_1.name}"
  network_security_group_name = "${azurerm_network_security_group.NSG_1.name}"
}

# Creacion de dos interfaces de red
resource "azurerm_network_interface" "NIC_1" {
    name                      = "NIC_lnxprueba01"
    location                  = "${var.AZURE_LOCATION}"
    resource_group_name       = "${azurerm_resource_group.RG_1.name}"
    network_security_group_id = "${azurerm_network_security_group.NSG_1.id}"
    ip_configuration {
        name                          = "ip-config"
        subnet_id                     = "${azurerm_subnet.SN_test1.id}"
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = "${azurerm_public_ip.PIP_1.id}"
    }
}

# Creacion de una VM Linux
resource "azurerm_virtual_machine" "VM_1" {
    # Nombre de la VM
    name = "vm-lnxprueba01"

    # Tamanio de la VM
    vm_size = "Standard_A0"

    # Ubicacion
    location = "eastus"

    # Resource group dentro del cual crear la VM
    resource_group_name = "${azurerm_resource_group.RG_1.name}"

    # Lista (con corchetes) de interfaces de red
    network_interface_ids = ["${azurerm_network_interface.NIC_1.id}"]

    storage_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "18.04-LTS"
        version   = "latest"
    }

    # Caracteristicas del tipo de disco de SO
    storage_os_disk {
        name              = "disk-lnxprueba01-rootfs"
        create_option     = "FromImage"
        managed_disk_type = "Standard_LRS"
    }

    # Parametros de SO
    os_profile {
        computer_name  = "srvlnx${var.OS_HOSTNAME}"
        admin_username = "${var.OS_USER}"
    }

    os_profile_linux_config {
        disable_password_authentication = true
        ssh_keys {
            path     = "/home/${var.OS_USER}/.ssh/authorized_keys"
            key_data = "${file("${var.PUBLIC_KEY}")}"
        }
    }
}
