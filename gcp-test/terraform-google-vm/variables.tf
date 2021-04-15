variable "vm_count" {
  type        = number
  description = "Number of VMs to create"
  default     = 1
}

variable "machine_type" {
  type        = string
  description = "VM machine type"
}

variable "zone_name" {
  type        = string
  description = "Zone name where VM should be deployed to"
}

variable "vm_name" {
  type        = string
  description = "VM name"
}

variable "boot_disk_size" {
  type        = number
  description = "Size of boot disk in GB"
}

variable "boot_disk_type" {
  type        = string
  description = "Type of boot disk"
  default     = "pd-ssd"
}

variable "boot_disk_auto_delete" {
  type        = bool
  description = "Whether to delete boot disk after VM removal"
  default     = true
}

variable "subnetwork" {
  type        = string
  description = "Subnetwork of VM"
}

variable "network" {
  type        = string
  description = "Network of VM"
}

variable "image_family" {
  type        = string
  description = "VM image family"
}

variable "image_project" {
  type        = string
  description = "VM image project"
}

variable "private_ips" {
  type        = list(string)
  description = "List of private IP for the VMs. Values values within the list are: auto or IPv4 private address"
  default     = ["auto"]
}

variable "public_ips" {
  type        = list(string)
  description = "List of public IPs for the VM. Values values within the list are: auto, none or IPv4 public address"
  default     = ["auto"]
}

variable "firewall_rules" {
  type        = list(map(string))
  description = "List of incoming firewall rules for the VM"
  default     = []
}

variable "ssd_data_disks" {
  type        = list(number)
  description = "List of sizes (in GB) for SSD data disks"
  default     = []
}

variable "labels" {
  type        = map(string)
  description = "Map of tags to apply to all resources"
  default     = {}
}
