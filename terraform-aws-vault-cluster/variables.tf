variable "create_kms_key" {
  type        = bool
  default     = false
  description = "Whether to create or not a KMS key"
}

variable "iam_vault_user" {
  type        = string
  description = "Default IAM user name for vault"
  default     = "vault_unseal_user"
}

variable "iam_user_policy_prefix" {
  type        = string
  description = "Policy prefix name for KMS service"
  default     = "kms_policy_"
}

variable "consul_os" {
  type        = string
  description = "Desired operating system name for EC2 instances"
  default     = "Amazon Linux 2"
}

variable "bastion_os" {
  type        = string
  description = "Desired operating system name for EC2 instances"
  default     = "Amazon Linux 2"
}

variable "vault_os" {
  type        = string
  description = "Desired operating system name for EC2 instances"
  default     = "Amazon Linux 2"
}

variable "force_destroy_iam_vault_user" {
  type        = bool
  default     = true
  description = "Force destroy of IAM user for vault"
}

variable "ca_cert_file" {
  type        = string
  description = "Name of the CA certificate file within the root module path"
}

variable "server_cert_file" {
  type        = string
  description = "Name of the server certificate file within the root module path"
}

variable "server_key_file" {
  type        = string
  description = "Name of the server key file within the root module path"
}

variable "certificate_arn" {
  type        = string
  description = "ARN of ACM certificate to associate to the load balancer"
}

#######################################
#           Network settings          #
#######################################
variable "network_settings" {
  type = list(object({
    type       = string
    subnet_id  = string
    consul_ips = list(string)
    vault_ips  = list(string)
  }))
}
#######################################
#######################################




#######################################
#           Common settings           #
#######################################
variable "bastion_ssh_cidr_block" {
  type        = string
  description = "Allowed CIDR block for incoming SSH traffic to the bastion host"
  default     = "0.0.0.0/0"
}

variable "keypair_public" {
  type        = string
  description = "Public key of the keypair"
}

variable "keypair_private" {
  type        = string
  description = "Private key of the keypair"
}

variable "keypair_name_prefix" {
  type        = string
  description = "Name prefix for the keypair"
  default     = "kp_vault"
}

variable "detailed_monitoring" {
  type        = bool
  description = "Whether to enable deatailed monitoring on EC2 instances"
  default     = false
}

variable "tags" {
  type        = map(string)
  description = "Tags to associate to all resources"
  default     = {}
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

variable "sg_bastion_name" {
  type        = string
  description = "Name of security group for bastion EC2 instances"
  default     = "sg_bastion"
}

variable "sg_bastion_description" {
  type        = string
  description = "Description of security group for bastion EC2 instances"
  default     = "SG for bastion nodes"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
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

variable "consul_instance_name" {
  type        = string
  description = "Name for the consul EC2 instances"
  default     = "consul"
}

variable "consul_instance_type" {
  type        = string
  description = "EC2 instance type for consul nodes"
  default     = "t3a.medium"
}

variable "sg_consul_name" {
  type        = string
  description = "Name of security group for Consul EC2 instances"
  default     = "sg_consul"
}

variable "sg_consul_description" {
  type        = string
  description = "Description of security group for Consul EC2 instances"
  default     = "SG for consul nodes"
}

variable "consul_vars" {
  type        = map(string)
  default     = {}
  description = "Map of consul variables that will be passed to ansible playbook"
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

variable "vault_instance_name" {
  type        = string
  description = "Name for the vault EC2 instances"
  default     = "vault"
}

variable "vault_certificate_name" {
  type        = string
  description = "Name of the vault certificate in ACM"
  default     = "vault_certificate"
}

variable "vault_instance_type" {
  type        = string
  description = "EC2 instance type for vault nodes"
  default     = "t3a.medium"
}

variable "vault_health_check_path" {
  type        = string
  default     = "/v1/sys/health"
  description = "Vault API path to check its health status"
}

variable "sg_vault_name" {
  type        = string
  description = "Name of security group for vault EC2 instances"
  default     = "sg_vault"
}

variable "sg_vault_description" {
  type        = string
  description = "Description of security group for vault EC2 instances"
  default     = "SG for vault nodes"
}

variable "vault_vars" {
  type = map(string)
  default = {
    vault_tls_disable = "1"
  }
  description = "Map of vault variables that will be passed to ansible playbook"
}

#######################################
#######################################







######################################
#        Load Balancer settings      #
######################################
variable "elb_name_prefix" {
  type        = string
  description = "Prefix name for the load balaancer"
  default     = "vault"
}

variable "elb_listener_port" {
  type        = number
  description = "External Load Balancer port"
  default     = 8200
}

variable "elb_listener_protocol" {
  type        = string
  default     = "TLS"
  description = "Protocol to configure in listener. Valid values: TCP TLS"
}

variable "elb_stickiness_enabled" {
  type        = bool
  default     = false
  description = "Whether to enable or not stickiness in the LB target group"
}

variable "elb_internal" {
  type        = bool
  default     = false
  description = "Whether to make the load balancer private or not"
}

variable "enable_deletion_protection" {
  type        = bool
  default     = false
  description = "Whether to enable deletion protection for the load balancer"
}

variable "elb_health_check_healthy_threshold" {
  type        = number
  default     = 3
  description = "The number of consecutive health checks successes required before considering an unhealthy target healthy"
}

variable "elb_health_check_interval" {
  type        = number
  default     = 10
  description = "The amount of time (in seconds) between health checks of an individual target"
}

variable "elb_sg_cidr_block" {
  type        = string
  default     = "0.0.0.0/0"
  description = "CIDR block to allow for incoming traffic to the load balancer"
}

variable "sg_elb_name" {
  type        = string
  description = "Name of security group for load balancer"
  default     = "sg_elb"
}

variable "sg_elb_description" {
  type        = string
  description = "Description of security group for load balancer"
  default     = "SG for load balancer"
}

######################################
######################################


