# Required inputs
variable "identifier" {
  type        = string
  description = "RDS identifier"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs where RDS should be placed to"
}

variable "master_username" {
  type        = string
  description = "Master username for the RDS instance. Only alphanumeric and underscores are allowed."
}

variable "master_password" {
  type        = string
  description = "Master password for the RDS instance"
}

# Optional inputs
variable "instance_size" {
  type        = string
  description = "Size of the RDS instance"
  default     = "db.t3.small"
}

variable "engine" {
  type        = string
  description = "Desired DB engine. Valid values are: mysql or postgres"
  default     = "mysql"
}

variable "engine_version" {
  type        = string
  description = "Desired version of the DB engine"
  default     = null
}

variable "engine_major_version" {
  type        = string
  description = "Desired major version of the DB engine"
  default     = null
}

variable "engine_family" {
  type        = string
  description = "Desired family of the DB engine"
  default     = null
}

variable "default_engine_versions" {
  type        = map(string)
  description = "Default values for engine versions"
  default = {
    mysql      = "5.7.28"
    postgres = "9.6.18"
  }
}

variable "default_engine_major_versions" {
  type        = map(string)
  description = "Default values for engine major versions"
  default = {
    mysql      = "5.7"
    postgres = "9.6"
  }
}

variable "default_engine_families" {
  type        = map(string)
  description = "Default values for engine families"
  default = {
    mysql      = "mysql5.7"
    postgres = "postgres9.6"
  }
}

variable "disk_size" {
  type        = number
  description = "Disk size for the RDS instance"
  default     = 5
}

variable "tags" {
  type        = map(string)
  description = "Mapping of common tags to apply to resources"
  default     = {}
}

variable "maintenance_window" {
  type        = string
  description = "Maintenance window"
  default     = "Mon:00:00-Mon:03:00"
}

variable "backup_window" {
  type        = string
  description = "(Default: 03:00-06:00) Backup window"
  default     = "03:00-06:00"
}

variable "port" {
  type        = string
  description = "Desired port to be used by DB engine. If omitted, conventional ports for MySQL (3303) or PostgreSQL (5432) are used"
  default     = null
}

variable "default_ports" {
  type        = map(string)
  description = "Default ports used by DB engines"
  default = {
    mysql      = "3306"
    postgres = "5432"
  }
}

variable "dbname" {
  type        = string
  description = "Name of initial database to create. If omitted, no database is created"
  default     = null
}

variable "backup_retention" {
  type        = number
  description = "Number of days to retain automated backups. By default (0), no backups are retained."
  default     = 0
}

variable "allowed_cidr_block" {
  type        = string
  description = ".CIDR block to allow communication from. It omitted, it defaults to the VPC's CIDR block."
  default     = null
}
