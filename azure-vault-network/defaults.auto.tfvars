primary_vnet_name     = "pri_vault-vnet"
primary_vnet_cidr     = "172.23.0.0/16"
primary_subnet_cidr   = "172.23.1.0/24"
primary_subnet_name   = "pri_vault_subnet"
secondary_vnet_name   = "sec_vault-vnet"
secondary_vnet_cidr   = "172.24.0.0/16"
secondary_subnet_cidr = "172.24.1.0/24"
secondary_subnet_name = "sec_vault_subnet"

tags = {
  Owner       = "angel.rengifo"
  TFProject   = "vault-azure-network"
  Group       = "Cloud"
  Description = "Arquitectura de red base para Vault en Cluster"
}
