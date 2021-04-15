variable "vsphere_user" {
  description = "vSphere privileged user"
  default     = ""
}

variable "vsphere_password" {
  description = "vSphere privileged user's password"
  default     = ""
}

variable "vsphere_server" {
  description = "vSphere/vCenter address"
  default     = ""
}

variable "vsphere_datacenter" {
  description = "vSphere datacenter"
  default     = ""
}

variable "vsphere_datastore_vm" {
  description = "vSphere datastore for VMs"
  default     = ""
}

variable "vsphere_resource_pool" {
  description = "vSphere resource pool for VMs"
  default     = ""
}

variable "vsphere_network" {
  description = "vSphere network for VMs"
  default     = ""
}

variable "vsphere_vm_template" {
  description = "vSphere VM template for new VMs"
  default     = ""
}

variable "vm_name" {
  description = "VM name"
  default     = ""
}

variable "vm_cpus" {
  description = "Number of CPUs for VM"
  default     = ""
}

variable "vm_ram" {
  description = "Amount of memory for VM"
  default     = ""
}

variable "vm_guest_id" {
  description = "Guest ID/Type for VM"
  default     = ""
}

variable "vm_network_adapter_type" {
  description = "Network adapter type for VM"
  default     = ""
}

variable "vm_disk_size" {
  description = "Disk size in GB for VM"
  default     = ""
}

variable "vm_disk_label" {
  description = "VM OS disk label"
  default     = ""
}

variable "vm_disk_controller_type" {
  description = "Disk controller type for VM"
  default     = ""
}

variable "vm_hostname" {
  description = "VM hostname"
  default     = ""
}

variable "vm_workgroup" {
  description = "VM workgroup"
  default     = ""
}

variable "vm_admin_user" {
  description = "Administrator user for OS"
  default     = ""
}

variable "vm_admin_password" {
  description = "Admin password for OS"
  default     = ""
}

variable "vm_ipv4_address" {
  description = "IPv4 address for VM"
  default     = ""
}

variable "vm_dns_server_list" {
  type        = "list"
  description = "DNS servers for OS"

  #default     = ""
}

variable "vm_ipv4_netmask" {
  description = "IPv4 netmask for VM"
  default     = ""
}

variable "vm_ipv4_gateway" {
  description = "IPv4 gateway for VM"
  default     = ""
}
