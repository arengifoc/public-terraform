variable "network_name" {
  type = string
}

variable "subnets" {
  type = list(map(string))
}

variable "routing_mode" {
  type = string
}

variable "project_id" {
  type = string
  default = null
}

variable "region_name" {
  type = string
}

variable "instances" {
  type = map(object({
    machine_type   = string
    name           = string
    image_family   = string
    image_project  = string
    zone_name      = string
    boot_disk_size = number
    boot_disk_type = string
    network        = string
    subnetwork     = string
    public_ip      = string
    private_ip     = string
    firewall_rules = map(object({ protocol = string, port = number }))
  }))
}

variable "ssh_key_name" {
  type        = string
  description = "Name of the ssh key file to generate"
}

variable "ssh_user" {
  type        = string
  description = "Name of the SSH user for the instances"
}
