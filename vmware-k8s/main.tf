terraform {
  backend "s3" {
    bucket = "sysadmin-company-arengifoc-terraform-states"
    key    = "dev/vmware-k8s/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "vsphere" {
  user                 = var.VMWARE_USER
  password             = var.VMWARE_PASSWORD
  vsphere_server       = var.VMWARE_HOST
  allow_unverified_ssl = true
}

# Declaracion del Data Center existente
data "vsphere_datacenter" "dc" {
  name = var.VSPHERE_DATACENTER
}

# Declaracion de Datastores existentes
data "vsphere_datastore" "datastore_vm" {
  name          = var.VSPHERE_DATASTORE_VM
  datacenter_id = data.vsphere_datacenter.dc.id
}

# Declaracion de resource pool existente
data "vsphere_resource_pool" "rpool" {
  name          = var.VSPHERE_RESOURCE_POOL
  datacenter_id = data.vsphere_datacenter.dc.id
}

# Declaracion de red existente
data "vsphere_network" "network1" {
  name          = var.VM_NETWORK
  datacenter_id = data.vsphere_datacenter.dc.id
}

# Declaracion de plantilla existente
data "vsphere_virtual_machine" "vm_template" {
  name          = var.VSPHERE_VM_TEMPLATE
  datacenter_id = data.vsphere_datacenter.dc.id
}

# Creacion de VM
resource "vsphere_virtual_machine" "vm1" {
  resource_pool_id = data.vsphere_resource_pool.rpool.id
  datastore_id     = data.vsphere_datastore.datastore_vm.id
  name             = var.VM_NAME
  folder           = var.VM_FOLDER
  num_cpus         = var.VM_CPUS
  memory           = var.VM_RAM
  guest_id         = var.VM_GUEST_ID
  scsi_type        = var.VM_DISK_CONTROLLER_TYPE

  network_interface {
    network_id   = data.vsphere_network.network1.id
    adapter_type = var.VM_NETWORK_ADAPTER_TYPE
  }

  disk {
    label            = var.VM_DISK_LABEL
    size             = var.VM_DISK_SIZE
    thin_provisioned = data.vsphere_virtual_machine.vm_template.disks.0.thin_provisioned
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.vm_template.id

    customize {
      linux_options {
        host_name  = var.VM_HOSTNAME
        domain = var.VM_DOMAIN
      }

      network_interface {
        ipv4_address    = var.VM_IPV4_ADDRESS
        ipv4_netmask    = var.VM_IPV4_NETMASK
        dns_server_list = var.VM_DNS_SERVER_LIST
      }

      ipv4_gateway = var.VM_IPV4_GATEWAY
    }
  }
}
