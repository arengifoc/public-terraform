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

#######################################
#           Network settings          #
#######################################
variable "primary_vpc_id" {
  type        = string
  description = "ID of the VPC where resources should be deployed to"
}

variable "secondary_vpc_id" {
  type        = string
  description = "ID of the VPC where resources should be deployed to"
  default     = null
}

variable "primary_network_settings" {
  type = list(object({
    type       = string
    subnet_id  = string
    consul_ips = list(string)
    vault_ips  = list(string)
  }))
}

variable "secondary_network_settings" {
  type = list(object({
    type       = string
    subnet_id  = string
    consul_ips = list(string)
    vault_ips  = list(string)
  }))
  default = []
}
#######################################
#######################################






#######################################
#           Common settings           #
#######################################
variable "desired_os" {
  type        = string
  description = "Nombre amigable de la AMI deseada. Ver valores en variable AMIS. Ejm Amazon Linux 2"
  default     = null
}

variable "primary_region" {
  type    = string
  default = "us-east-1"
}

variable "secondary_region" {
  type    = string
  default = "us-east-2"
}

variable "bastion_ssh_cidr_block" {
  type        = string
  description = "Allowed CIDR block for incoming SSH traffic to the bastion host"
}

variable "keypair" {
  type        = string
  description = "Keypair to associate to EC2 instances"
}

variable "tags" {
  type        = map(string)
  description = "Tags to associate to all resources"
}

variable "bastion_instance_name" {
  type        = string
  description = "Name for the bastion EC2 instances"
  default     = "bastion"
}

variable "bastion_instance_type" {
  type        = string
  description = "EC2 instance type for bastion nodes"
  default     = "t3a.nano"
}
#######################################
#######################################






#######################################
#           Consul settings           #
#######################################
variable "consul_port" {
  type        = number
  description = "Consul listening port"
  default     = 8300
}

variable "primary_consul_instance_name" {
  type        = string
  description = "Name for the consul EC2 instances"
  default     = "primary_consul"
}

variable "secondary_consul_instance_name" {
  type        = string
  description = "Name for the consul EC2 instances"
  default     = "secondary_consul"
}

variable "primary_consul_instance_type" {
  type        = string
  description = "EC2 instance type for consul nodes"
}

variable "secondary_consul_instance_type" {
  type        = string
  description = "EC2 instance type for consul nodes"
}
#######################################
#######################################





######################################
#           Vault settings           #
######################################
variable "vault_port" {
  type        = number
  description = "Vault listening port"
  default     = 8200
}

variable "primary_vault_instance_name" {
  type        = string
  description = "Name for the vault EC2 instances"
  default     = "vault"
}

variable "secondary_vault_instance_name" {
  type        = string
  description = "Name for the vault EC2 instances"
  default     = "vault"
}

variable "primary_vault_instance_type" {
  type        = string
  description = "EC2 instance type for vault nodes"
}

variable "secondary_vault_instance_type" {
  type        = string
  description = "EC2 instance type for vault nodes"
  default     = null
}

variable "vault_health_check_path" {
  type        = string
  default     = "/v1/sys/health"
  description = "Vault API path to check its health status"
}
#######################################
#######################################







######################################
#        Load Balancer settings      #
######################################
variable "alb_listener_port" {
  type        = number
  description = "External Load Balancer port"
  default     = 8200
}

variable "alb_listener_protocol" {
  type        = string
  default     = "HTTP"
  description = "Protocol to configure in listener. Valid values: HTTP HTTPS"
}

variable "alb_stickiness_enabled" {
  type        = bool
  default     = false
  description = "Whether to enable or not stickiness in the LB target group"
}

variable "alb_health_check_matcher" {
  type        = string
  default     = "200"
  description = "Default HTTP expected from targets to consider them healthy"
}

variable "alb_health_check_unhealthy_threshold" {
  type        = number
  default     = 3
  description = "The number of consecutive health checks failures required before considering a target unhealthy"
}

variable "alb_health_check_healthy_threshold" {
  type        = number
  default     = 3
  description = "The number of consecutive health checks successes required before considering an unhealthy target healthy"
}

variable "alb_health_check_timeout" {
  type        = number
  default     = 5
  description = "The amount of time (in seconds) during which no response means a failed health check"
}

variable "alb_health_check_interval" {
  type        = number
  default     = 20
  description = "The amount of time (in seconds) between health checks of an individual target"
}

variable "alb_sg_cidr_block" {
  type        = string
  default     = "0.0.0.0/0"
  description = "CIDR block to allow for incoming traffic to the load balancer"
}

######################################
######################################


