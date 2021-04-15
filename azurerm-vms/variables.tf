variable "rg_name" { type = string }

variable "location" { type = string }

variable "vnet_name" { type = string }

variable "vnet_cidr" { type = string }

variable "subnet_names" { type = list(string) }

variable "subnet_cidrs" { type = list(string) }

variable "tags" { type = map(string) }

variable "vm-linux-name" { type = string }

# variable "vm-windows-name" { type = string }

variable "public_sshkey" { type = string }