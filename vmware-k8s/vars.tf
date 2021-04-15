variable "VMWARE_USER" {
  type = string
}

variable "VMWARE_PASSWORD" {
  type = string
}

variable "VMWARE_HOST" {
  type = string
}

variable "VSPHERE_DATACENTER" {
  type = string
}

variable "VSPHERE_DATASTORE_VM" {
  type = string
}

variable "VSPHERE_RESOURCE_POOL" {
  type = string
}

variable "VM_NETWORK" {
  type = string
}

variable "VSPHERE_VM_TEMPLATE" {
  type = string
}

variable "VM_NAME" {
  type = string
}

variable "VM_FOLDER" {
  type = string
}

variable "VM_CPUS" {
  type = number
}

variable "VM_RAM" {
  type = number
}

variable "VM_GUEST_ID" {
  type = string
}

variable "VM_DISK_CONTROLLER_TYPE" {
  type    = string
  default = "pvscsi"
}

variable "VM_NETWORK_ADAPTER_TYPE" {
  type    = string
  default = "vmxnet3"
}

variable "VM_DISK_LABEL" {
  type    = string
  default = "disk0"
}

variable "VM_DISK_SIZE" {
  type = number
  default = 50
}

variable "VM_HOSTNAME" {
  type    = string
}

variable "VM_DOMAIN" {
  type    = string
}

# variable "VM_ADMIN_PASSWORD" {
#   type    = string
# }

variable "VM_IPV4_ADDRESS" {
  type    = string
}

variable "VM_IPV4_NETMASK" {
  type    = string
}

variable "VM_DNS_SERVER_LIST" {
  type    = list
}

variable "VM_IPV4_GATEWAY" {
  type    = string
}

