variable "tags" {
  type        = map(string)
  description = "Tags to associate to all resources"
}

# Variables for primary location (mandatory)
variable "primary_vnet_name" {
  type        = string
  description = "Name for the VNET"
}

variable "primary_vnet_cidr" {
  type        = string
  description = "CIDR for VNET"
}

variable "primary_subnet_cidr" {
  type        = string
  description = "CIDRs for primary subnet"
}

variable "primary_subnet_name" {
  type        = string
  description = "Names for secondary subnet"
}

variable "primary_location" {
  type    = string
  default = "East US"
}

variable "primary_rg_name" {
  type        = string
  default     = "VAULT_RG_PRIMARY"
  description = "Name for primary resource groups"
}


# Variables for secondary location (optional)
variable "secondary_vnet_name" {
  type        = string
  description = "Name for the VNET"
  default     = null
}

variable "secondary_vnet_cidr" {
  type        = string
  description = "CIDR for VNET"
  default     = null
}

variable "secondary_subnet_cidr" {
  type        = string
  description = "CIDRs for secondary subnet"
  default     = null
}

variable "secondary_subnet_name" {
  type        = string
  description = "Names for secondary subnet"
  default     = null
}

variable "secondary_location" {
  type    = string
  default = "East US 2"
}

variable "secondary_rg_name" {
  type        = string
  default     = "VAULT_RG_SECONDARY"
  description = "Name for secondary resource groups"
}
