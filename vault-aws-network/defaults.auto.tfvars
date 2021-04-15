primary_vpc_name        = "primary_vault-vpc"
primary_vpc_cidr        = "172.23.0.0/16"
primary_azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
primary_private_subnets = ["172.23.1.0/24", "172.23.2.0/24", "172.23.3.0/24"]
primary_public_subnets  = ["172.23.11.0/24", "172.23.12.0/24", "172.23.13.0/24"]

secondary_vpc_name        = "secondary_vault-vpc"
secondary_vpc_cidr        = "172.24.0.0/16"
secondary_azs             = ["us-east-2a", "us-east-2b", "us-east-2c"]
secondary_private_subnets = ["172.24.1.0/24", "172.24.2.0/24", "172.24.3.0/24"]
secondary_public_subnets  = ["172.24.11.0/24", "172.24.12.0/24", "172.24.13.0/24"]

tags = {
  Owner       = "angel.rengifo"
  TFProject   = "vault-aws-network"
  Group       = "Cloud"
  Description = "Arquitectura de red base para Vault en Cluster"
}
