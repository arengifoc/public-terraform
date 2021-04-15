# terraform {
#   backend "remote" {
#     hostname     = "app.terraform.io"
#     organization = "FAMRENCAR"

#     workspaces {
#       name = "vault-dr-cluster"
#     }
#   }
# }

provider "aws" {
  region = "us-east-1"
  alias  = "primary"
}

provider "aws" {
  region = "us-east-2"
  alias  = "secondary"
}

module "primary" {
  providers = {
    aws = aws.primary
  }
  source = "./terraform-aws-vault-cluster/"

  vpc_id                 = "vpc-xxxxxxxx"
  bastion_ssh_cidr_block = "0.0.0.0/0"
  bastion_instance_type  = "t3a.small"
  consul_instance_type   = "t3a.micro"
  vault_instance_type    = "t3a.micro"
  create_kms_key         = false
  iam_vault_user         = "vaultuser"
  ca_cert_file           = file("${path.module}/ca-cert.pem")
  server_cert_file       = file("${path.module}/vault.solucionescompany.com-cert.pem")
  server_key_file        = file("${path.module}/vault.solucionescompany.com-key.pem")
  keypair_private        = file("${path.module}/keypair")
  keypair_public         = file("${path.module}/keypair.pub")
  certificate_arn        = "arn:aws:acm:us-east-1:609209792151:certificate/5b38264d-54f9-4805-ae1f-67a23c203d59"

  vault_vars = {
    vault_storage = "raft"
    vault_tls_disable = "0"
    vault_hostname = "vault.solucionescompany.com"
  }
  consul_vars = {
    consul_user    = "admin"
    consul_dc      = "vault2"
    consul_version = "1.7.1"
  }

  network_settings = [
    {
      type       = "private"
      subnet_id  = "subnet-xxxxxxxx"
      consul_ips = ["172.23.1.20"]
      vault_ips  = ["172.23.1.30"]
    },
    {
      type       = "private"
      subnet_id  = "subnet-xxxxxxxx"
      consul_ips = ["172.23.2.20"]
      vault_ips  = ["172.23.2.30"]
    },
    {
      type       = "private"
      subnet_id  = "subnet-xxxxxxxx"
      consul_ips = ["172.23.3.20"]
      vault_ips  = []
    },
    {
      type       = "public"
      subnet_id  = "subnet-xxxxxxxx"
      consul_ips = []
      vault_ips  = []
    },
    {
      type       = "public"
      subnet_id  = "subnet-xxxxxxxx"
      consul_ips = []
      vault_ips  = []
    },
    {
      type       = "public"
      subnet_id  = "subnet-xxxxxxxx"
      consul_ips = []
      vault_ips  = []
    }
  ]

  tags = {
    Owner       = "angel.rengifo"
    TFProject   = "vault-dr-cluster"
    Group       = "Pre Sales Multi Cloud Peru"
    Description = "Demo de arquitectura Vault en Cluster"
  }
}

# module "secondary" {
#   providers = {
#     aws = aws.secondary
#   }
#   source = "./terraform-aws-vault-cluster/"

#   vpc_id                 = "vpc-xxxxxxxx"
#   bastion_ssh_cidr_block = "0.0.0.0/0"
#   consul_instance_type   = "t3a.micro"
#   vault_instance_type    = "t3a.micro"
#   create_kms_key         = false
#   iam_vault_user         = "vaultuser"
#   ca_cert_file           = file("${path.module}/ca-cert.pem")
#   server_cert_file       = file("${path.module}/vault.solucionescompany.com-cert.pem")
#   server_key_file        = file("${path.module}/vault.solucionescompany.com-key.pem")
#   keypair_private        = file("${path.module}/keypair")
#   keypair_public         = file("${path.module}/keypair.pub")

#   network_settings = [
#     {
#       type       = "private"
#       subnet_id  = "subnet-xxxxxxxx"
#       consul_ips = ["172.24.1.20"]
#       vault_ips  = ["172.24.1.30"]
#     },
#     {
#       type       = "private"
#       subnet_id  = "subnet-xxxxxxxx"
#       consul_ips = ["172.24.2.20"]
#       vault_ips  = ["172.24.2.30"]
#     },
#     {
#       type       = "private"
#       subnet_id  = "subnet-xxxxxxxx"
#       consul_ips = ["172.24.3.20"]
#       vault_ips  = []
#     },
#     {
#       type       = "public"
#       subnet_id  = "subnet-xxxxxxxx"
#       consul_ips = []
#       vault_ips  = []
#     },
#     {
#       type       = "public"
#       subnet_id  = "subnet-xxxxxxxx"
#       consul_ips = []
#       vault_ips  = []
#     },
#     {
#       type       = "public"
#       subnet_id  = "subnet-xxxxxxxx"
#       consul_ips = []
#       vault_ips  = []
#     }
#   ]

#   tags = {
#     Owner       = "angel.rengifo"
#     TFProject   = "vault-cluster-company"
#     Group       = "Pre Sales Multi Cloud Peru"
#     Description = "Demo de arquitectura Vault en Cluster"
#   }
# }

