provider "azurerm" {
  features {}
}

module "primary" {
  source = "../../../../terraform-azure-vault-cluster/"

  resource_group         = "VAULT_RG_PRIMARY"
  vnet                   = "pri_vault-vnet"
  bastion_ssh_cidr_block = "0.0.0.0/0"
  bastion_vm_size        = "Standard_B1ms"
  consul_vm_size         = "Standard_B1ms"
  vault_vm_size          = "Standard_B1ms"
  create_key_vault       = false
  ca_cert_file           = file("${path.module}/ca-cert.pem")
  server_cert_file       = file("${path.module}/vault.solucionescompany.com-cert.pem")
  server_key_file        = file("${path.module}/vault.solucionescompany.com-key.pem")
  ssh_private_data_key   = file("${path.module}/sshkey")
  ssh_public_data_key    = file("${path.module}/sshkey.pub")
  bastion_subnet         = "pri_vault_subnet"
  vault_subnet           = "pri_vault_subnet"
  consul_subnet          = "pri_vault_subnet"
  vault_ips              = ["172.23.1.10", "172.23.1.11"]
  consul_ips             = ["172.23.1.12", "172.23.1.13", "172.23.1.14"]

  vault_vars = {
    vault_storage     = "raft"
    vault_tls_disable = "0"
    vault_hostname    = "vault.solucionescompany.com"
  }

  consul_vars = {
    consul_user    = "admin"
    consul_dc      = "vault2"
    consul_version = "1.7.1"
  }
}
