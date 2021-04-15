resource "azurerm_resource_group" "RG01" {
    name     = "${var.PREFIX}-RG01"
    location = "${var.AZURE_LOCATION}"
}

resource "azurerm_virtual_network" "vnet01" {
    name                = "${var.PREFIX}-vnet01"
    address_space       = ["10.80.70.0/24"]
    location            = "${var.AZURE_LOCATION}"
    resource_group_name = "${azurerm_resource_group.RG01.name}"
}

resource "azurerm_subnet" "subnet01" {
    name                 = "${var.PREFIX}-subnet01"
    resource_group_name  = "${azurerm_resource_group.RG01.name}"
    virtual_network_name = "${azurerm_virtual_network.vnet01.name}"
    address_prefix       = "10.80.70.0/26"
}

resource "azurerm_public_ip" "pip01" {
    name                = "${var.PREFIX}-pip01"
    location            = "${var.AZURE_LOCATION}"
    resource_group_name = "${azurerm_resource_group.RG01.name}"
    allocation_method   = "Static"
}

resource "azurerm_network_interface" "nic01" {
    name                = "${var.PREFIX}-nic01"
    location            = "${var.AZURE_LOCATION}"
    resource_group_name = "${azurerm_resource_group.RG01.name}"
    ip_configuration {
        name                          = "ip-config"
        subnet_id                     = "${azurerm_subnet.subnet01.id}"
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = "${azurerm_public_ip.pip01.id}"
    }
}

resource "azurerm_virtual_machine" "vm01" {
    # obligatorio
    name = "${var.PREFIX}-vm01"
    # obligatorio
    vm_size = "Standard_B1ms"
    # obligatorio
    location = "eastus"
    # obligatorio
    resource_group_name = "${azurerm_resource_group.RG01.name}"
    # Lista (con corchetes) de interfaces de red
    # obligatorio
    network_interface_ids = ["${azurerm_network_interface.nic01.id}"]
    storage_image_reference {
        publisher = "MicrosoftWindowsServer"
        offer     = "WindowsServer"
        sku       = "2008-R2-SP1"
        version   = "latest"
    }
    # obligatorio
    storage_os_disk {
        name              = "disk-rootfs"
        create_option     = "FromImage"
        managed_disk_type = "Standard_LRS"
    }
    os_profile {
        computer_name  = "${var.OS_HOSTNAME}"
        admin_username = "${var.OS_USER}"
        admin_password = "${var.OS_USER_PW}"
    }
    os_profile_windows_config {
        provision_vm_agent = true
        timezone = "SA Pacific Standard Time"
    }
}
