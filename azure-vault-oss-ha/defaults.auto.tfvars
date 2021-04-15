primary_vnet_name     = "vnet_primary"
primary_vnet_cidr     = "172.23.0.0/16"
primary_subnet_cidr   = "172.23.1.0/24"
primary_subnet_name   = "subnet_primary"
primary_rg_name       = "RG_PRIMARY"

secondary_vnet_name   = "vnet_secondary"
secondary_vnet_cidr   = "172.24.0.0/16"
secondary_subnet_cidr = "172.24.1.0/24"
secondary_subnet_name = "subnet_secondary"
secondary_rg_name     = "RG_SECONDARY"

tags = {
  Owner       = "angel.rengifo"
  TFProject   = "azure-vault-oss-ha"
  Group       = "Cloud"
  Description = "Arquitectura de red base para Vault en Cluster"
}
