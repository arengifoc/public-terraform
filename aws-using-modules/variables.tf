variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "ami_owners" {
  description = "Common AMI owners"
  type        = "map"

  default = {
    centos = "679593333241"
    redhat = "309956199498"
    amazon = "137112412989"
    ubuntu = "679593333241"
  }
}

variable "ami_patterns" {
  description = "Common AMI name patterns"
  type        = "map"

  default = {
    centos7 = "CentOS Linux 7 x86_64 HVM*"
    centos6 = "CentOS Linux 6 x86_64 HVM*"
    redhat7 = "RHEL-7.6*"
    amazon  = "amzn-ami*"
    amazon2 = "amzn2-ami*"
  }
}

variable "private_key" {
  description = "Path to my private key"
  default     = "~/.ssh/id_rsa"
}

variable "public_key" {
  description = "Path to my public key"
  default     = "~/.ssh/id_rsa.pub"
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

variable "vpc_id" {
  description = "VPC ID"
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

variable "subnet_filter" {
  default = ""
}

variable "instance_name" {
  description = "Name of the instance"
  default     = ""
}
