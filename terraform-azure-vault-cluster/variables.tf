variable "create_key_vault" {
  type        = bool
  default     = false
  description = "Whether to create or not a Azure Key Vault key"
}

variable "bastion_ssh_cidr_block" {
  type        = string
  description = "Allowed CIDR block for incoming SSH traffic to the bastion host"
  default     = "0.0.0.0/0"
}

variable "bastion_os_publisher" {
  type    = string
  default = "OpenLogic"
}

variable "bastion_os_offer" {
  type    = string
  default = "CentOS"
}

variable "bastion_os_sku" {
  type    = string
  default = "8_2"
}

variable "bastion_subnet" {
  type = string
}

variable "ca_cert_file" {
  type        = string
  description = "Name of the CA certificate file within the root module path"
}

variable "server_cert_file" {
  type        = string
  description = "Name of the server certificate file within the root module path"
}

variable "server_key_file" {
  type        = string
  description = "Name of the server key file within the root module path"
}

#######################################
#           Network settings          #
#######################################
# variable "network_settings" {
#   type = list(object({
#     type       = string
#     subnet_id  = string
#     consul_ips = list(string)
#     vault_ips  = list(string)
#   }))
# }

variable "resource_group" {
  type = string
}

variable "vnet" {
  type = string
}

#######################################
#######################################


#######################################
#           Common settings           #
#######################################
variable "tags" {
  type        = map(string)
  description = "Tags to associate to all resources"
  default     = {}
}

variable "bastion_vm_name" {
  type    = string
  default = "bastion"
}

variable "bastion_vm_size" {
  type    = string
  default = "Standard_B1ms"
}

variable "bastion_public_ip_type" {
  type    = string
  default = "Dynamic"
}

variable "admin_username" {
  type    = string
  default = "vaultadmin"
}

variable "ssh_public_data_key" {
  type = string
}

variable "ssh_private_data_key" {
  type = string
}
#######################################
#######################################





#######################################
#           Consul settings           #
#######################################
variable "consul_port" {
  type        = number
  description = "Consul listening port"
  default     = 8300
}

variable "consul_vm_name" {
  type        = string
  description = "Name for the consul VMs on primary site"
  default     = "consul"
}

variable "consul_vm_size" {
  type        = string
  description = "VM size for consul nodes on primary site"
  default     = "Standard_B1ms"
}

# variable "consul_nsg_rules" {
#   type = list(map(any))
# }

variable "consul_vars" {
  type        = map(string)
  default     = {}
  description = "Map of consul variables that will be passed to ansible playbook"
}

variable "consul_os_publisher" {
  type    = string
  default = "OpenLogic"
}

variable "consul_os_offer" {
  type    = string
  default = "CentOS"
}

variable "consul_os_sku" {
  type    = string
  default = "8_2"
}

variable "consul_subnet" {
  type = string
}

variable "consul_ips" {
  type = list(string)
}

variable "consul_azs" {
  type    = list(string)
  default = ["1", "2", "3"]
}
#######################################
#######################################



######################################
#           Vault settings           #
######################################
variable "vault_port" {
  type        = number
  description = "Vault listening port"
  default     = 8200
}

variable "vault_vm_name" {
  type        = string
  description = "Name for the vault VMs on primary site"
  default     = "vault"
}

variable "vault_vm_size" {
  type        = string
  description = "VM size for vault nodes on primary site"
  default     = "Standard_B1ms"
}

variable "vault_certificate_name" {
  type        = string
  description = "Name of the vault certificate in ACM"
  default     = "vault_certificate"
}

variable "vault_health_check_path" {
  type        = string
  default     = "/v1/sys/health"
  description = "Vault API path to check its health status"
}

# variable "vault_nsg_rules" {
#   type = list(map(any))
# }

variable "vault_vars" {
  type = map(string)
  default = {
    vault_tls_disable = "1"
  }
  description = "Map of vault variables that will be passed to ansible playbook"
}

variable "vault_os_publisher" {
  type    = string
  default = "OpenLogic"
}

variable "vault_os_offer" {
  type    = string
  default = "CentOS"
}

variable "vault_os_sku" {
  type    = string
  default = "8_2"
}

variable "vault_subnet" {
  type = string
}

variable "vault_ips" {
  type = list(string)
}

variable "vault_azs" {
  type    = list(string)
  default = ["1", "2", "3"]
}
#######################################
#######################################




