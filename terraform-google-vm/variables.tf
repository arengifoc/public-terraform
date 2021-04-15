variable "vm_count" {
  type        = number
  description = "(Default: 1) Number of VMs to create. Default: 1"
  default     = 1
}

variable "machine_type" {
  type        = string
  description = "(Default: f1-micro) VM machine type. Default"
  default     = "f1-micro"
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
  description = "(Default: 30) Size of boot disk in GB. Default"
  default     = 30
}

variable "boot_disk_type" {
  type        = string
  description = "(Default: pd-ssd) Type of boot disk. Valid values: pd-standard or pd-ssd."
  default     = "pd-ssd"
}

variable "boot_disk_auto_delete" {
  type        = bool
  description = "(Default: true) Whether to delete boot disk after VM removal."
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
  description = "(Default: debian-10) VM image family. Valid values can be get by running 'gcloud compute images list'"
  default     = "debian-10"
}

variable "image_project" {
  type        = string
  description = "(Default: debian-cloud) VM image project. Valid values can be by running 'gcloud compute images list'"
  default     = "debian-cloud"
}

variable "private_ips" {
  type        = list(string)
  description = "(Default: auto) List of private IPs for each VM. Values values within the list are: auto or IPv4 private address"
  default     = ["auto"]
}

variable "public_ips" {
  type        = list(string)
  description = "(Default: auto) List of public IPs for each VM. Values values within the list are: auto, none or IPv4 public address"
  default     = ["auto"]
}

variable "firewall_rules" {
  type        = list(map(string))
  description = "(Default: [{ rule_name = \"fw-ingress-rdp\", protocol = \"tcp\", port = \"3389\", sources = \"0.0.0.0/0\" }, { rule_name = \"fw-ingress-ssh\", protocol = \"tcp\", port = \"22\", sources = \"0.0.0.0/0\" }]) List of incoming firewall rules for the VM."
  default     = [{ rule_name = \"fw-ingress-rdp\", protocol = \"tcp\", port = \"3389\", sources = \"0.0.0.0/0\" }, { rule_name = \"fw-ingress-ssh\", protocol = \"tcp\", port = \"22\", sources = \"0.0.0.0/0\" }]
}

variable "ssd_data_disks" {
  type        = list(number)
  description = "(Default: []) List of sizes (in GB) for SSD data disks"
  default     = []
}

variable "labels" {
  type        = map(string)
  description = "(Default: {}) Map of labels to apply to all resources"
  default     = {}
}
