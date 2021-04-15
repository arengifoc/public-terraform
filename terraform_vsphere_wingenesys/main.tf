# Declaracion del Data Center existente
data "vsphere_datacenter" "dc" {
  name = "${var.vsphere_datacenter}"
}

# Declaracion de Datastores existentes
data "vsphere_datastore" "datastore_vm" {
  name          = "${var.vsphere_datastore_vm}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

# Declaracion de resource pool existente
data "vsphere_resource_pool" "rpool" {
  name          = "${var.vsphere_resource_pool}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

# Declaracion de red existente
data "vsphere_network" "network1" {
  name          = "${var.vsphere_network}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

# Declaracion de plantilla existente
data "vsphere_virtual_machine" "vm_template" {
  name          = "${var.vsphere_vm_template}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

# Creacion de VM
resource "vsphere_virtual_machine" "vm1" {
  name             = "${var.vm_name}"
  resource_pool_id = "${data.vsphere_resource_pool.rpool.id}"
  datastore_id     = "${data.vsphere_datastore.datastore_vm.id}"
  num_cpus         = "${var.vm_cpus}"
  memory           = "${var.vm_ram}"
  guest_id         = "${var.vm_guest_id}"
  scsi_type        = "${var.vm_disk_controller_type}"

  network_interface {
    network_id   = "${data.vsphere_network.network1.id}"
    adapter_type = "${var.vm_network_adapter_type}"
  }

  disk {
    label            = "${var.vm_disk_label}"
    size             = "${var.vm_disk_size}"
    thin_provisioned = "${data.vsphere_virtual_machine.vm_template.disks.0.thin_provisioned}"
  }

  clone {
    template_uuid = "${data.vsphere_virtual_machine.vm_template.id}"

    customize {
      windows_options {
        computer_name  = "${var.vm_hostname}"
        workgroup      = "${var.vm_workgroup}"
        admin_password = "${var.vm_admin_password}"
      }

      network_interface {
        ipv4_address    = "${var.vm_ipv4_address}"
        ipv4_netmask    = "${var.vm_ipv4_netmask}"
        dns_server_list = "${var.vm_dns_server_list}"
      }

      ipv4_gateway = "${var.vm_ipv4_gateway}"
    }
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i ${var.vm_ipv4_address}, -e ansible_user=${var.vm_admin_user} -e ansible_password=${var.vm_admin_password} -e ansible_port=5986 -e ansible_connection=winrm -e ansible_winrm_server_cert_validation=ignore provisioning/main.yml"
  }
}
