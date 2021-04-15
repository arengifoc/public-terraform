primary_vpc_id = ""

primary_network_settings = [
  {
    type       = "private"
    subnet_id  = ""
    consul_ips = ["172.23.1.20"]
    vault_ips  = ["172.23.1.30"]
  },
  {
    type       = "private"
    subnet_id  = ""
    consul_ips = ["172.23.2.20"]
    vault_ips  = ["172.23.2.30"]
  },
  {
    type       = "private"
    subnet_id  = ""
    consul_ips = ["172.23.3.20"]
    vault_ips  = []
  },
  {
    type       = "public"
    subnet_id  = ""
    consul_ips = []
    vault_ips  = []
  },
  {
    type       = "public"
    subnet_id  = ""
    consul_ips = []
    vault_ips  = []
  },
  {
    type       = "public"
    subnet_id  = ""
    consul_ips = []
    vault_ips  = []
  }
]

secondary_network_settings = []

secondary_vpc_id = ""

bastion_ssh_cidr_block = "0.0.0.0/0"


# Common settings
desired_os = "Amazon Linux 2"
keypair    = "kp-angel.rengifo"
tags = {
  Owner       = "angel.rengifo"
  TFProject   = "vault-cluster-company"
  Group       = "Cloud"
  Description = "Demo de arquitectura Vault en Cluster"
}

# EC2 instance settings
primary_consul_instance_type   = "t3a.micro"
secondary_consul_instance_type = "t3a.micro"
primary_vault_instance_type    = "t3a.micro"
secondary_vault_instance_type  = "t3a.micro"

# ALB settings
alb_listener_port     = 8200
alb_listener_protocol = "HTTPS"
