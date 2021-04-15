resource "azurerm_public_ip" "pip01" {
    name                = "pip-${var.BASE_NAME}"
    location            = "${var.AZURE_LOCATION}"
    resource_group_name = "${var.AZURE_RG}"
    allocation_method   = "Static"
}

resource "azurerm_network_interface" "nic01" {
    name                = "nic-${var.BASE_NAME}"
    location            = "${var.AZURE_LOCATION}"
    resource_group_name = "${var.AZURE_RG}"
    ip_configuration {
        name                          = "ip-config"
        subnet_id                     = "${var.AZURE_SUBNET_ID}"
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = "${azurerm_public_ip.pip01.id}"
    }
}

resource "azurerm_virtual_machine" "vm01" {
    # *Nombre de VM
    name = "SRV${var.BASE_NAME}"
    # *Tamanio de VM
    vm_size = "${var.AZURE_VM_SIZE}"
    # *Ubicacion
    location = "eastus"
    # *Resource group
    resource_group_name = "${var.AZURE_RG}"
    # Lista (con corchetes) de interfaces de red
    # obligatorio
    network_interface_ids = ["${azurerm_network_interface.nic01.id}"]
    storage_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "18.04-LTS"
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
    os_profile_linux_config {
        disable_password_authentication = true
        ssh_keys {
            path     = "/home/${var.OS_USER}/.ssh/authorized_keys"
            key_data = "${file("${var.PUBLIC_KEY}")}"
        }
    }
}
