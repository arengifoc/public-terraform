provider "google" {
  region      = var.region_name
  project     = var.project_id
  credentials = file("account.json")
}

module "vpc" {
  source       = "terraform-google-modules/network/google"
  version      = "~> 2.3"
  network_name = var.network_name
  project_id   = var.project_id
  routing_mode = var.routing_mode

  subnets = [
    for item in var.subnet_names :
    merge(
      {
        subnet_region = var.region_name
        subnet_name   = item
        subnet_ip     = element(var.subnet_cidrs, index(var.subnet_names, item))
        description   = element(var.subnet_descs, index(var.subnet_names, item))
      }
    )
  ]

  routes = [
    {
      name              = "egress-internet-test"
      description       = "route through IGW to access internet"
      destination_range = "0.0.0.0/0"
      tags              = "egress-inet"
      next_hop_internet = "true"
    }
  ]
}

module "bastion" {
  # source  = "app.terraform.io/FAMRENCAR/vm/google"
  # version = "1.0.3"
  source = "./terraform-google-vm"

  zone_name      = var.vm_bastion_zone
  network        = module.vpc.network_name
  subnetwork     = join("", setintersection(module.vpc.subnets_names, [var.vm_bastion_subnet]))
  vm_count       = var.vm_bastion_count
  vm_name        = var.vm_bastion_name
  machine_type   = var.vm_bastion_machine_type
  boot_disk_size = var.vm_bastion_boot_disk_size
  image_family   = var.vm_bastion_image_family
  image_project  = var.vm_bastion_image_project
  private_ips    = var.vm_bastion_private_ips
  public_ips     = var.vm_bastion_public_ips
  ssd_data_disks = var.vm_bastion_ssd_data_disks
  firewall_rules = var.vm_bastion_firewall_rules
}

