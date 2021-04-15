locals {
  bastion_setup_vars = {
    privkey          = var.ssh_private_data_key
    vault_vm_name    = var.vault_vm_name
    consul_vm_name   = var.consul_vm_name
    consul_ips       = var.consul_ips
    vault_ips        = var.vault_ips
    consul_ssh_user  = var.admin_username
    vault_ssh_user   = var.admin_username
    bastion_ssh_user = var.admin_username
    consul_vars = merge(var.consul_vars, {
      consul_port = var.consul_port
    })
    vault_vars = merge(var.vault_vars, {
      ca_cert_file     = var.ca_cert_file
      server_cert_file = var.server_cert_file
      server_key_file  = var.server_key_file
      #   aws_access_key   = var.create_kms_key == true ? aws_iam_access_key.iam_access_key[0].id : "NONE"
      #   aws_kms_key_id   = var.create_kms_key == true ? aws_kms_key.vault_key[0].id : "NONE"
      #   aws_region       = var.create_kms_key == true ? data.aws_region.current.name : "NONE"
      #   aws_secret_key   = var.create_kms_key == true ? aws_iam_access_key.iam_access_key[0].secret : "NONE"
      vault_port = var.vault_port
    })
  }
}
