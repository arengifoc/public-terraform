# Required inputs
variable "vpc_name" {
  type        = string
  description = "VPC name"
}

variable "vpc_cidr_block" {
  type        = string
  description = "VPC CIDR block"
}

# Optional inputs
variable "az_names" {
  type        = list(string)
  description = "List of AZs where subnets should be created. If omitted, it defaults to the first 3 AZs of current region"
  default = []
}

variable "private_subnet_cidr_blocks" {
  type        = list(string)
  description = "List of CIDR blocks for private subnets"
  default     = []
}

variable "public_subnet_cidr_blocks" {
  type        = list(string)
  description = "List of CIDR blocks for public subnets"
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "Mapping of common tags to apply to all resources"
  default     = {}
}

variable "enable_nat_gw" {
  type        = bool
  description = "Whether to enable or not NAT gateway per AZ"
  default     = false
}
