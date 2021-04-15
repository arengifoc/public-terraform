# se agrego creacion de usuario con llaves ssh, provisioner file y remote-exec


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
    vm_size = "Standard_A0"
    # obligatorio
    location = "eastus"
    # obligatorio
    resource_group_name = "${azurerm_resource_group.RG01.name}"
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
    }
    os_profile_linux_config {
        disable_password_authentication = true
        ssh_keys {
            path     = "/home/${var.OS_USER}/.ssh/authorized_keys"
            key_data = "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAymNMTOWQUIDm/LK0oIUQv0iTqUA/gwUWqWcA4CCu7PDa7vkAb3E2cGVwc3eBmTKT+v02rDU4fTqfhzGNzCPnCg7QIJqvQk+YsueaCLcUwww0zBQvBP0gJmhUSxT5aYyYgCPn0IH/OzhN5y3CpTfmODokjcKs5oWHruluIfyIrbcJC7rd+avJtD9HdGlHtVtz0cbQ3+clcpOAxIhK1LcXzoZKEBuG20lX1I27jSpVmXxzW3IEB0e1itPiaCMWeGyg+CwelKZIs3MsDTy3RPBqt1tWRZtHC4fR9G9s4/f0AGeX8jTgXviU8SsabH2Lvg4e4hdYImuibjA9YOeioy8U+w=="
        }
    }
    connection {
        user = "${var.OS_USER}"
        private_key = "${file("${var.private_key}")}"
    }
    provisioner "remote-exec" {
        inline = [
            "sudo apt-get update",
            "sudo apt-get install -y stress-ng",
            "sudo mkdir /scripts",
            "sudo chmod o+w /scripts",
        ]
    }
    provisioner "file" {
        source = "/etc/fstab"
        destination = "/tmp/fstab"
    }
    provisioner "file" {
        source = "/data/documentos/config/scripts/company/unix/pivot/"
        destination = "/scripts"
    }
    provisioner "remote-exec" {
        inline = [
            "sudo chmod o-w /scripts",
            "sudo chmod 755 /scripts/*",
            "sudo chown -R root:root /scripts",
        ]
    }
}
