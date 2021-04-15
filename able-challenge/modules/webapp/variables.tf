variable "os" { default = "Ubuntu Server 18.04" }
variable "network_cidr" { default = "10.7.0.0/16" }
variable "public_subnet_cidrs" { default = ["10.7.0.0/24", "10.7.1.0/24"] }
variable "private_subnet_cidrs" { default = ["10.7.2.0/24", "10.7.3.0/24"] }
variable "zone_names" { default = ["us-east-1a", "us-east-1b"] }
variable "tags" {
  default = {
    owner     = "Angel Rengifo"
    tfproject = "able-challenge"
  }
}

variable "name_prefix" { default = "test" }

variable "vm-size" { default = "t3a.small" }

variable "instance_size" {
  type        = string
  description = "Size of the RDS instance"
  default     = "db.t3.small"
}

variable "engine" {
  default = "postgres"
}

variable "engine_version" {
  default = "9.6.19"
}

variable "engine_major_version" {
  default = "9.6"
}

variable "engine_family" {
  default = "postgres9.6"
}

variable "disk_size" {
  default = 5
}

variable "maintenance_window" {
  default = "Mon:00:00-Mon:03:00"
}

variable "backup_window" {
  default = "03:00-06:00"
}

variable "port" { default = 5432 }

variable "backup_retention" {
  default = 0
}

variable "webapp_count" { default = 1 }
variable "backend_protocol" { default = "HTTP" }
variable "backend_port" { default = "80" }
variable "certificate_arn" { default = null }
variable "stickiness_enabled" { default = true }

# Required variables
variable "db_identifier" {}
variable "public_sshkey" {}
variable "master_username" {}
variable "master_password" {}
variable "db_name" {}
