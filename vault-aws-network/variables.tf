variable "tags" {
  type        = map(string)
  description = "Tags to associate to all resources"
}

# Variables for primary region (mandatory)
variable "primary_vpc_name" {
  type        = string
  description = "Name for the VPC"
}

variable "primary_vpc_cidr" {
  type        = string
  description = "CIDR for VPC"
}

variable "primary_azs" {
  type        = list(string)
  description = "List of availability zones"
}

variable "primary_private_subnets" {
  type        = list(string)
  description = "List of CIDRs for private subnets"
}

variable "primary_public_subnets" {
  type        = list(string)
  description = "List of CIDRs for public subnets"
}

variable "primary_region" {
  type    = string
  default = "us-east-1"
}

# Variables for secondary region (optional)
variable "secondary_vpc_name" {
  type        = string
  description = "Name for the VPC"
  default     = null
}

variable "secondary_vpc_cidr" {
  type        = string
  description = "CIDR for VPC"
  default     = null
}

variable "secondary_azs" {
  type        = list(string)
  description = "List of availability zones"
  default     = []
}

variable "secondary_private_subnets" {
  type        = list(string)
  description = "List of CIDRs for private subnets"
  default     = []
}

variable "secondary_public_subnets" {
  type        = list(string)
  description = "List of CIDRs for public subnets"
  default     = []
}

variable "secondary_region" {
  type    = string
  default = "us-east-2"
}

