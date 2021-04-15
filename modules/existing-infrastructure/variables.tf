variable "vpc_name" {
  description = "Tag based name of the desired VPC"
  default     = ""
}

variable "subnet_name" {
  description = "Tag based name of the desired subnet"
  default     = ""
}

variable "os_user" {
  description = "OS user used to connect to instance through SSH/RDP/WinRM"
  type        = "map"

  default = {
    centos = "centos"
    amazon = "ec2-user"
    redhat = "ec2-user"
    ubuntu = "ubuntu"
  }
}

variable "owner_name" {
  description = "Name of the desired owner"
  default     = ""
}

variable "ami_name" {
  description = "Name of the desired AMI name"
  default     = ""
}

variable "os_rootfs_disk_size" {
  description = "Size of OS disk, in GB"
  default     = "50"
}

variable "os_swap_disk_size" {
  description = "Size of swap disk, in GB"
  default     = ""
}

variable "instance_name" {
  description = "Name of the instance"
  default     = ""
}

variable "public_ssh_key" {
  default = "mykey.pub"
}

variable "crear_vpc" {}
