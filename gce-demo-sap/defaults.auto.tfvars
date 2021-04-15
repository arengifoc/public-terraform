region_name = "us-east1"

network_name = "pocsapnet"
routing_mode = "GLOBAL"
subnets = [
  {
    subnet_name = "pocsapnet-pubsubnet01"
    subnet_ip   = "10.10.1.0/26"
    description = "Subnet publica 1"
  },
  {
    subnet_name = "pocsapnet-pubsubnet02"
    subnet_ip   = "10.10.2.0/26"
    description = "Subnet publica 2"
  },
  {
    subnet_name           = "pocsapnet-privsubnet01"
    subnet_ip             = "10.10.3.0/24"
    subnet_private_access = "true"
    description           = "Subnet privada 1"
  },
  {
    subnet_name           = "pocsapnet-privsubnet02"
    subnet_ip             = "10.10.4.0/24"
    subnet_private_access = "true"
    description           = "Subnet privada 2"
  }
]

ssh_user     = "company-admin"
ssh_key_name = "sshkey"
instances = {
  "bastion" = {
    machine_type   = "f1-micro"
    name           = "bastion"
    image_family   = "sles-15-sp1-sap"
    image_project  = "suse-sap-cloud"
    zone_name      = "us-east1-b"
    boot_disk_size = 10
    boot_disk_type = "pd-ssd"
    network        = "pocsapnet"
    subnetwork     = "pocsapnet-pubsubnet01"
    public_ip      = "auto"
    private_ip     = "10.10.1.10"
    firewall_rules = {
      "fw-ingress-ssh"  = { protocol = "tcp", port = 22 }
      "fw-ingress-http" = { protocol = "tcp", port = 80 }
    }
  }
  "sap-hana" = {
    machine_type   = "f1-micro"
    name           = "sap-hana"
    image_family   = "sles-15-sp1-sap"
    image_project  = "suse-sap-cloud"
    zone_name      = "us-east1-b"
    boot_disk_size = 10
    boot_disk_type = "pd-ssd"
    network        = "pocsapnet"
    subnetwork     = "pocsapnet-privsubnet01"
    public_ip      = "none"
    private_ip     = "10.10.3.200"
    firewall_rules = {
      "fw-ingress-icmp" = { protocol = "icmp", port = -1 }
      "fw-ingress-ssh"  = { protocol = "tcp", port = 22 }
    }
  }
  "sap-nw-as" = {
    machine_type   = "f1-micro"
    name           = "sap-nw-as"
    image_family   = "sles-12-sp5-sap"
    image_project  = "suse-sap-cloud"
    zone_name      = "us-east1-b"
    boot_disk_size = 10
    boot_disk_type = "pd-ssd"
    network        = "pocsapnet"
    subnetwork     = "pocsapnet-privsubnet01"
    public_ip      = "none"
    private_ip     = "auto"
    firewall_rules = {
      "fw-ingress-icmp" = { protocol = "icmp", port = -1 }
      "fw-ingress-ssh"  = { protocol = "tcp", port = 22 }
    }
  }
}

# private_ip     = "10.10.3.201"
