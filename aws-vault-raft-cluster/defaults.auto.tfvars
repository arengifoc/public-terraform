tags = {
  Owner       = "angel.rengifo"
  TFProject   = "aws-vault-raft-cluster"
  Group       = "Cloud"
  Description = "Demo de cluster Vault Enterprise con Consul OSS"
}

vpc_name       = "vault-vpc"
vpc_cidr       = "172.25.0.0/16"
azs            = ["us-east-1a", "us-east-1b", "us-east-1c"]
public_subnets = ["172.25.11.0/24", "172.25.12.0/24", "172.25.13.0/24"]
