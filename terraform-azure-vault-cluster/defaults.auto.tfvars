# primary_resource_group = "VAULT_RG_PRIMARY"
# primary_vnet           = "primary_vault-vnet"
# primary_subnet         = "vault_pri_subnet1"

# bastion_public_ip_type  = "Dynamic"
# primary_bastion_vm_name = "bastion"
# primary_bastion_vm_size = "Standard_B1ms"
# primary_vault_vm_name   = "vault"
# primary_vault_vm_size   = "Standard_B1ms"
# primary_consul_vm_name  = "consul"
# primary_consul_vm_size  = "Standard_B1ms"
# admin_username          = "arengifo"
# ssh_public_data_key     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDoSTBFTqvD8pUREvf3J+kS6SFWa2psg5BvWzurY1q9UlDONxPRQDUE5wKwTlYWSz2OluT6cfdXmW5uSC6+Wd/C8GnqF/u7RbTRD7ahCGsQR5/+4OD72OH84Mz9JKiaFGpCdIJpXrn46q3W89bIO1Pj1vjabmWUKq3MVfZsuOfKG/pqwxfysIEO8efK8R3lTynZ5NswaT3lqjels8zpNkoKtnjsKExWV6MZ9fRIlN/qalwhBLBBS8G8L/QkNPvgOtwJH/c6WOFjVepew6/953P+H+sbFcp5U++BubPRw6OeQT3eZHKs89iM0l+c2e+jXEWySEezxMrjmv9zPfsFzpDZ arengifo@debianista"
# os_image_publisher      = "Canonical"
# os_image_offer          = "UbuntuServer"
# os_image_sku            = "18.04-LTS"
# tags = {
#   Owner       = "angel.rengifo"
#   TFProject   = "vault-azure-cluster"
#   Group       = "Cloud"
#   Description = "Arquitectura de red base para Vault en Cluster"
# }

# vault_nsg_rules = [
#   {
#     name                       = "in_ssh"
#     description                = "Allow incoming SSH traffic"
#     protocol                   = "tcp"
#     source_port_range          = "*"
#     destination_port_range     = "22"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#     access                     = "allow"
#     priority                   = 100
#     direction                  = "Inbound"
#   },
#   {
#     name                       = "out_all"
#     description                = "Allow all outgoing traffic"
#     protocol                   = "*"
#     source_port_range          = "*"
#     destination_port_range     = "*"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#     access                     = "allow"
#     priority                   = 4096
#     direction                  = "Outbound"
#   }
# ]

# consul_nsg_rules = [
#   {
#     name                       = "in_ssh"
#     description                = "Allow incoming SSH traffic"
#     protocol                   = "tcp"
#     source_port_range          = "*"
#     destination_port_range     = "22"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#     access                     = "allow"
#     priority                   = 100
#     direction                  = "Inbound"
#   },
#   {
#     name                       = "out_all"
#     description                = "Allow all outgoing traffic"
#     protocol                   = "*"
#     source_port_range          = "*"
#     destination_port_range     = "*"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#     access                     = "allow"
#     priority                   = 4096
#     direction                  = "Outbound"
#   }
# ]
