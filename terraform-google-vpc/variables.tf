variable "network_name" {
  type        = string
  description = "Network name"
}

variable "subnet_names" {
  type        = list(string)
  description = "List of names for each network"
}

variable "subnet_cidrs" {
  type        = list(string)
  description = "List of CIDRs for each subnet"
}

variable "subnet_descs" {
  type        = list(string)
  description = "List of descriptions for each subnet"
}

variable "region_name" {
  type        = string
  description = "(Default: us-east1) Name of region"
  default     = "us-east1"
}

variable "routing_mode" {
  type        = string
  description = "(Default: GLOBAL) Routing mode. Valid values: GLOBAL, REGIONAL"
  default     = "GLOBAL"
}
