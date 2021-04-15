# Parametros de proyecto
ssh_user   = "company-admin"

# Parametros de red
region_name  = "us-east1"
zone_name    = "us-east1-c"
network_name = "pocsapnet"
routing_mode = "GLOBAL"
subnet_names = ["pocsap-pub-subnet01", "pocsap-pub-subnet02"]
subnet_cidrs = ["10.10.1.0/26", "10.10.3.0/24"]
subnet_descs = ["Subnet publica 1", "Subnet publica 2"]

# Labels
labels = {
  owner     = "angelrengifo"
  tfproject = "gcp-poc-sap"
  group     = "multicloud"
}

# Parametros de VM Bastion Windows
vm_bastion_count          = 1
vm_bastion_subnet         = "pocsap-pub-subnet01"
vm_bastion_zone           = "us-east1-c"
vm_bastion_name           = "bastion"
vm_bastion_machine_type   = "n2-standard-2"
vm_bastion_boot_disk_size = 50
vm_bastion_image_family   = "windows-2019"
vm_bastion_image_project  = "windows-cloud"
vm_bastion_private_ips    = ["10.10.1.10"]
vm_bastion_public_ips     = ["auto"]
vm_bastion_ssd_data_disks = [170]
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
    sources   = "10.10.1.0/26,10.10.3.0/24"
  }
]

# Parametros de VM SAP NW AS
vm_sapnwas_count          = 1
vm_sapnwas_subnet         = "pocsap-pub-subnet02"
vm_sapnwas_zone           = "us-east1-c"
vm_sapnwas_name           = "sap-nw-as"
vm_sapnwas_machine_type   = "n2-standard-2"
vm_sapnwas_boot_disk_size = 30
vm_sapnwas_image_family   = "sles-15-sp1-sap"
vm_sapnwas_image_project  = "suse-sap-cloud"
vm_sapnwas_private_ips    = ["10.10.3.201"]
vm_sapnwas_public_ips     = ["auto"]
vm_sapnwas_ssd_data_disks = [20, 90, 50, 30]
vm_sapnwas_firewall_rules = [
  {
    rule_name = "fw-ingress-ssh"
    protocol  = "tcp"
    port      = "22"
    sources   = "10.10.1.0/26,10.10.3.0/24"
  },
  {
    rule_name = "fw-ingress-icmp"
    protocol  = "icmp"
    port      = "-1"
    sources   = "10.10.1.0/26,10.10.3.0/24"
  }
]

# Parametros de VM SAP Hana
vm_saphana_count          = 1
vm_saphana_subnet         = "pocsap-pub-subnet02"
vm_saphana_zone           = "us-east1-c"
vm_saphana_name           = "sap-hana"
vm_saphana_machine_type   = "n2-standard-2"
vm_saphana_boot_disk_size = 10
vm_saphana_image_family   = "sles-15-sp1-sap"
vm_saphana_image_project  = "suse-sap-cloud"
vm_saphana_private_ips    = ["10.10.3.200"]
vm_saphana_public_ips     = ["auto"]
vm_saphana_ssd_data_disks = [64, 256, 30, 80, 180]
vm_saphana_firewall_rules = [
  {
    rule_name = "fw-ingress-ssh"
    protocol  = "tcp"
    port      = "22"
    sources   = "10.10.1.0/26,10.10.3.0/24"
  },
  {
    rule_name = "fw-ingress-icmp"
    protocol  = "icmp"
    port      = "-1"
    sources   = "10.10.1.0/26,10.10.3.0/24"
  }
]
