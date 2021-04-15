variable "region_name" {
  type = string
}

variable "network_name" {
  type = string
}

variable "subnet_names" {
  type = list(string)
}

variable "subnet_cidrs" {
  type = list(string)
}

variable "subnet_descs" {
  type = list(string)
}

variable "routing_mode" {
  type = string
}

variable "project_id" {
  type = string
  default = null
}

variable "ssh_key_pub_data" {
  type = string
}

variable "ssh_user" {
  type = string
  default = "company-admin"
}

variable "labels" {
  type = map(string)
  description = "Map of tags to apply to all resources"
  default = {}
}


variable "vm_bastion_name" {
  type = string
  description = "Name of SAP NW AS VM"
}

variable "vm_bastion_machine_type" {
  type = string
  description = "Machine type of SAP NW AS VM"
}

variable "vm_bastion_count" {
  type = string
  description = "Number of SAP NW AS VMs to create"
}

variable "vm_bastion_boot_disk_size" {
  type = string
  description = "Boot disk size (in GB) of SAP NW AS VM"
}

variable "zone_name" {
  type = string
  description = "Zone where VMs should be deployed"
}

variable "vm_bastion_image_family" {
  type = string
}

variable "vm_bastion_image_project" {
  type = string
}

variable "vm_bastion_private_ips" {
  type = list(string)
}

variable "vm_bastion_public_ips" {
  type = list(string)
}

variable "vm_bastion_ssd_data_disks" {
  type = list(number)
}

variable "vm_bastion_firewall_rules" {
  type = list(map(string))
}

variable "vm_bastion_subnet" {
  type = string
}

variable "vm_bastion_zone" {
  type = string
}
