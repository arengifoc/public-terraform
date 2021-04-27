variable "amis" {
  type = map(object({
    short_name   = string
    owners       = string
    name_pattern = string
    default_user = string
    product_code = string
    disk_type    = string
  }))
  default = {
    "Amazon Linux" = {
      short_name   = "amzn"
      owners       = "137112412989"
      name_pattern = "amzn-ami-hvm-????.??.*.????????-x86_64-gp2"
      default_user = "ec2-user"
      disk_type    = "ebs"
      product_code = null
    }
    "Amazon Linux 2" = {
      short_name   = "amzn2"
      owners       = "137112412989"
      name_pattern = "amzn2-ami-hvm-2.0.????????-x86_64-gp2"
      default_user = "ec2-user"
      disk_type    = "ebs"
      product_code = null
    }
    "Ubuntu Server 18.04" = {
      short_name   = "ubuntu18.04"
      owners       = "099720109477"
      name_pattern = "ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"
      default_user = "ubuntu"
      disk_type    = "ebs"
      product_code = null
    }
    "CentOS 7" = {
      short_name   = "centos7"
      owners       = "aws-marketplace"
      name_pattern = null
      default_user = "centos"
      disk_type    = "ebs"
      product_code = "aw0evgkw8e5c1q413zgy5pjce"
    }
    "Windows 2016" = {
      short_name   = "windows2016"
      owners       = "801119661308"
      name_pattern = "Windows_Server-2016-English-Full-Base-*"
      default_user = "administrator"
      disk_type    = "ebs"
      product_code = null
    }
  }
}

variable "os" {
  type        = string
  description = "Name of the operating system"
}
