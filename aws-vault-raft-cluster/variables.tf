variable "tags" {
  type        = map(string)
  description = "Tags to associate to all resources"
  default     = {}
}

variable "vpc_name" {
  type        = string
  description = "Name for the VPC"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR for VPC"
}

variable "azs" {
  type        = list(string)
  description = "List of availability zones"
}

variable "public_subnets" {
  type        = list(string)
  description = "List of CIDRs for public subnets"
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "vault_vars" {
  type        = map(string)
  description = "List of ansible variables for vault deployment"
  default = {
    vault_tls_disable = "1"
  }
}

variable "keypair_name_prefix" {
  type    = string
  default = "vaultraft"
}

variable "keypair_file" {
  type    = string
  default = "sshkey"
}
