# Declaracion del Data Center existente
data "vsphere_datacenter" "dc" {
  name = "COT-DEV01"
}

# Declaracion de Datastores existentes
data "vsphere_datastore" "datastore1" {
  name          = "c1_3p74_sat_cld_id005"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_datastore" "datastore2" {
  name          = "c1_3p74_sas_isos_id109"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

# Declaracion de resource pool existente
data "vsphere_resource_pool" "rpool1" {
  name          = "PILOTO-LINUX"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

# Declaracion de red existente
data "vsphere_network" "network1" {
  name          = "V_ISO_LAN_1401"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

# Declaracion de plantilla existente
data "vsphere_virtual_machine" "template1" {
  name          = "C1LNXTEST03"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

# Creacion de VM
resource "vsphere_virtual_machine" "vm1" {
  name             = "C1LNXTEST04"
  resource_pool_id = "${data.vsphere_resource_pool.rpool1.id}"
  datastore_id     = "${data.vsphere_datastore.datastore1.id}"
  num_cpus         = 1
  memory           = 3072
  guest_id         = "rhel7_64Guest"

  network_interface {
    network_id = "${data.vsphere_network.network1.id}"
  }

  disk {
    label            = "disk0"
    size             = 20
    thin_provisioned = "${data.vsphere_virtual_machine.template1.disks.0.thin_provisioned}"
  }

  #disk {
    #label       = "disk1"
    #size        = "35"
    #unit_number = 1
  #}

  clone {
    template_uuid = "${data.vsphere_virtual_machine.template1.id}"

    customize {
      linux_options {
        host_name = "srvlnxtest03"
        domain    = "company.com"
      }

      network_interface {
        ipv4_address = "10.240.30.213"
        ipv4_netmask = "24"
      }

      ipv4_gateway = "10.240.30.1"
    }
  }
}
