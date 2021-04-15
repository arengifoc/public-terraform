variable "tags" {
  type        = map(string)
  description = "Tags to associate to all resources"
}

variable "vpc_id" {
  type        = string
  description = "ID of the VPC where resources should be deployed to"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of Subnet IDs where resources should be deployed to"
}

variable "vpc_id_sec" {
  type        = string
  description = "ID of the VPC where resources should be deployed to"
}

variable "subnet_ids_sec" {
  type        = list(string)
  description = "List of Subnet IDs where resources should be deployed to"
}
