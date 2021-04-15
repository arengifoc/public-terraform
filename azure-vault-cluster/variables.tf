variable "primary_vnet" {
  type        = string
  description = "Name of VNET in primary site"
}

variable "primary_rg_name" {
  type        = string
  description = "Name of RG in primary site"
}

variable "secondary_vnet" {
  type        = string
  description = "Name of VNET in secondary site"
}

variable "secondary_rg_name" {
  type        = string
  description = "Name of RG in secondary site"
}