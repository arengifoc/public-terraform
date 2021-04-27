variable "instance_count" {
  description = "Number of EC2 instances to create"
  type        = number
  default     = 1
}

variable "ami_id" {
  description = "ID of AMI to use for the EC2 instance"
  type        = string
  default     = ""
}

variable "desired_os" {
  description = "Name of desired OS for the AMI when ami_id!=\"\". Valid options are: Amazon Linux, Amazon Linux 2, Ubuntu Server 18.04, CentOS 7 and Windows 2016"
  type        = string
  default     = "Amazon Linux 2"
}

variable "default_user" {
  description = "Default SSH user for the EC2 instance. This directly depends on the value of ami_id or desired_os"
  type        = string
  default     = "ec2-user"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3a.small"
}

variable "detailed_monitoring" {
  description = "Whether to enable or not detailed monitoring for the EC2 instance"
  type        = bool
  default     = false
}

variable "assign_public_ip" {
  description = "Whether to assign or not a public IP address to the EC2 instance"
  type        = bool
  default     = true
}

variable "subnet_id" {
  description = "ID of the subnet where the EC2 instance should be created"
  type        = string
}

variable "user_data" {
  description = "User Data field for the EC2 instance"
  type        = string
  default     = null
}

variable "tags" {
  description = "Maps to assign to the resources"
  type        = map(string)
  default     = {}
}

variable "random_suffix" {
  description = "Whether to use a random suffix in resource names"
  type        = bool
  default     = true
}

variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "ec2demo"
}

variable "create_keypair" {
  description = "Whether to create a new SSH keypair or not"
  type        = bool
  default     = true
}

variable "keypair_name" {
  description = "Name of an existing SSH Keypair to use when create_keypair=false"
  type        = string
  default     = ""
}

variable "pubkey" {
  description = "Path where SSH public key is located for creating the new keypair"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "create_sg" {
  description = "Whether to create a new Security Group or use a existing one"
  type        = bool
  default     = true
}

variable "sg_ids" {
  description = "List of Security Group IDs to attach to the EC2 instance when create_sg=false"
  type        = list(string)
  default     = []
}

variable "sg_rules" {
  description = "List of security group ingress rules in the form of PORT,PROTOCOL,SOURCE_CIDR"
  type        = list(string)
  default     = ["22,tcp,0.0.0.0"]
}

