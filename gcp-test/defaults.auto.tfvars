# Parametros de proyecto
ssh_user   = "company-admin"
ssh_key_pub_data = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDlexVb+vy1JgqX8HC0cpvLbGiMsN6W/+4+XBQOwhlztwPBatZJhcWho7sayywSTK98wtZQlQPZNL4DP0zTKZR3583yV3jTvOp/4kTMU6qBCdtOIKqnJlQf2Hfp+HbGTmuWtdHi2rT0p4vlng5fKHwzASD2hH3e6WxIulttCQhQCxoRht5+yy5OBDolYPg0aaj4BLjBBjQfM407AVRA985C9jf03TiLnQCrow/40/t0ZtaaBVSpZkZSROpgXuelxJ0dBcydx5aaJCL6gzM/9XQ97eW7d6ww90bdIj/gcngc+DlkMpqJRfgYAT+yKvn1vi4B+//TxoTSjEw6oxjiY3gV arengifo@debianista"
project_id = "poc-sap-gcp-2020"

# Parametros de red
region_name  = "us-east1"
zone_name    = "us-east1-c"
network_name = "testnet"
routing_mode = "GLOBAL"
subnet_names = ["test-pub-subnet01", "test-pub-subnet02"]
subnet_cidrs = ["10.30.1.0/26", "10.30.3.0/24"]
subnet_descs = ["Subnet publica 1", "Subnet publica 2"]

# Labels
labels = {
  owner     = "angelrengifo"
  tfproject = "gcp-test"
  group     = "multicloud"
}

# Parametros de VM Bastion Windows
vm_bastion_count          = 1
vm_bastion_subnet         = "test-pub-subnet01"
vm_bastion_zone           = "us-east1-c"
vm_bastion_name           = "bastiontest"
vm_bastion_machine_type   = "n2-standard-2"
vm_bastion_boot_disk_size = 50
vm_bastion_image_family   = "windows-2019"
vm_bastion_image_project  = "windows-cloud"
vm_bastion_private_ips    = ["10.30.1.10"]
vm_bastion_public_ips     = ["auto"]
vm_bastion_ssd_data_disks = [10,8]
vm_bastion_firewall_rules = [
  {
    rule_name = "fw-ingress-rdp"
    protocol  = "tcp"
    port      = "3389"
    sources   = "0.0.0.0/0"
  },
  {
    rule_name = "fw-ingress-icmp"
    protocol  = "icmp"
    port      = "-1"
    sources   = "10.30.1.0/26,10.30.3.0/24"
  }
]
