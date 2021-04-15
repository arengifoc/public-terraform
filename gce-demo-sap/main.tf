terraform {
  backend "remote" {
    organization = "FAMRENCAR"

    workspaces {
      name = "gce-demo-sap"
    }
  }
}

# provider setup
provider "google" {
  region = var.region_name
}

module "vpc" {
  source       = "terraform-google-modules/network/google"
  version      = "~> 2.3"
  network_name = var.network_name
  project_id   = var.project_id
  routing_mode = var.routing_mode
  subnets = [
    for item in var.subnets :
    merge(
      {
        subnet_region = var.region_name
      },
      item
    )
  ]

  routes = [
    {
      name              = "egress-internet"
      description       = "route through IGW to access internet"
      destination_range = "0.0.0.0/0"
      tags              = "egress-inet"
      next_hop_internet = "true"
    }
  ]
}

# a way to merge the list of instance attributes in an organized way so we can use it to create several instances by reusing code
locals {
  firewall_resources = flatten(
    [
      for instance_key, instance_values in var.instances :
      [
        for key, value in lookup(instance_values, "firewall_rules") :
        {
          instance_name = instance_key
          network       = lookup(instance_values, "network", null)
          rule_name     = key
          rule_value    = value
        }
      ]
    ]
  )
}

# data source for querying compute images
data "google_compute_image" "selected" {
  for_each = var.instances
  family   = lookup(each.value, "image_family", null)
  project  = lookup(each.value, "image_project", null)
}

# VM instances
resource "google_compute_instance" "this_vm" {
  for_each                  = var.instances
  allow_stopping_for_update = true # it allows to resize VMs
  machine_type              = lookup(each.value, "machine_type", null)
  name                      = lookup(each.value, "name", null)
  zone                      = lookup(each.value, "zone_name", null)
  tags = [
    for key, value in lookup(each.value, "firewall_rules", null) :
    "${lookup(each.value, "network", null)}-${lookup(each.value, "name", null)}-${key}"
  ]

  boot_disk {
    auto_delete = true
    initialize_params {
      size  = lookup(each.value, "boot_disk_size", null)
      type  = lookup(each.value, "boot_disk_type", null)
      image = data.google_compute_image.selected[each.key].self_link
    }
  }

  network_interface {
    network    = lookup(each.value, "network", null)
    subnetwork = lookup(each.value, "subnetwork", null)
    network_ip = ! contains(["", "none", "auto"], lookup(each.value, "private_ip", "auto")) ? lookup(each.value, "private_ip", null) : null

    dynamic "access_config" {
      for_each = ! contains(["", "none"], lookup(each.value, "public_ip", "none")) ? [1] : []
      content {
        nat_ip = lookup(each.value, "public_ip", "auto") != "auto" ? lookup(each.value, "public_ip", "auto") : null
      }
    }
  }
  depends_on = [
    module.vpc, # if we don't wait for module.vpc to complete, gce instance creation might randomly fail
    google_compute_router_nat.nat_router
  ]
}

# firewall rules for instances
resource "google_compute_firewall" "this_firewall" {
  for_each = {
    for item in local.firewall_resources : "${item.network}.${item.instance_name}.${item.rule_name}" => item.rule_value
  }

  network     = split(".", each.key)[0]
  name        = replace(each.key, ".", "-")
  target_tags = [replace(each.key, ".", "-")]
  direction   = "INGRESS"

  allow {
    protocol = each.value.protocol
    ports    = each.value.port > 0 ? [each.value.port] : null
  }
  depends_on = [module.vpc] # we need to wait for module.vpc.* to complete before creating this resource
}

data "template_file" "sshkey" {
  template = file("${path.module}/sshkey.pub")
}

resource "google_compute_project_metadata_item" "ssh_key" {
  key   = "ssh-keys"
  value = <<EOF
${var.ssh_user}:${data.template_file.sshkey.rendered}
EOF
}

resource "google_compute_router" "router" {
  name       = "cloud-router"
  region     = var.region_name
  network    = var.network_name
  depends_on = [module.vpc]
}

resource "google_compute_router_nat" "nat_router" {
  name = "router-nat"
  # nat_ip_allocate_option             = "AUTO_ONLY"
  nat_ip_allocate_option             = "MANUAL_ONLY"
  nat_ips                            = google_compute_address.address.*.id
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  router                             = google_compute_router.router.name
  region                             = var.region_name
  depends_on                         = [module.vpc]
}

##
resource "google_compute_address" "address" {
  count  = 2
  name   = "nat-manual-ip-${count.index}"
  region = var.region_name
}
