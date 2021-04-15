variable "aws_profile" {}

variable "aws_region" {
  default = "us-east-1"
}

variable "vpc_name" {}

variable "subnet_name" {}

variable "owner_name" {}

variable "ami_name" {}

variable "instance_type" {}

variable "instance_name" {}

variable "os_rootfs_disk_size" {}

variable "os_rootfs_disk_type" {}

variable "private_ip" {}

variable "private_ssh_key" {}

variable "public_ssh_key" {}

variable "key_name" {
  default = "KP-personal"
}

variable "crear_vpc" {}
