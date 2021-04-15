# data source for querying compute images
data "google_compute_image" "selected" {
  family  = var.image_family
  project = var.image_project
}

# VM instances
resource "google_compute_instance" "this_vm" {
  count = var.vm_count

  name                      = var.vm_count > 1 ? format("%s-%d", var.vm_name, count.index + 1) : var.vm_name
  machine_type              = var.machine_type
  allow_stopping_for_update = true
  zone                      = var.zone_name
  labels                    = var.labels

  boot_disk {
    auto_delete = var.boot_disk_auto_delete

    initialize_params {
      size  = var.boot_disk_size
      type  = var.boot_disk_type
      image = data.google_compute_image.selected.self_link
    }
  }

  dynamic "attached_disk" {
    for_each = [for item in google_compute_disk.ssd_data.*.id : element(split("/", item), 5)]
    content {
      source      = attached_disk.value
      device_name = join("-", slice(split("-", attached_disk.value), 1, 4))
      mode        = "READ_WRITE"
    }
  }

  network_interface {
    network    = var.network
    subnetwork = var.subnetwork
    network_ip = var.private_ips[count.index] == "" || var.private_ips[count.index] == "auto" ? null : var.private_ips[count.index]

    dynamic "access_config" {
      for_each = var.public_ips[count.index] == "" || var.public_ips[count.index] == "none" ? [] : [1]
      content {
        nat_ip = var.public_ips[count.index] == "auto" ? null : var.public_ips[count.index]
      }
    }
  }

  tags = [
    for item in var.firewall_rules :
    "${var.network}-${var.vm_count > 1 ? format("%s-%d", var.vm_name, count.index + 1) : var.vm_name}-${item.rule_name}"
  ]

  lifecycle {
    ignore_changes = [
      attached_disk
    ]
  }
}

# # firewall rules for instances
resource "google_compute_firewall" "this_firewall" {
  count = length(var.firewall_rules)

  network       = var.network
  name          = "${var.network}-${var.vm_count > 1 ? format("%s-%d", var.vm_name, count.index + 1) : var.vm_name}-${var.firewall_rules[count.index].rule_name}"
  target_tags   = ["${var.network}-${var.vm_count > 1 ? format("%s-%d", var.vm_name, count.index + 1) : var.vm_name}-${var.firewall_rules[count.index].rule_name}"]
  direction     = "INGRESS"
  source_ranges = [for item in split(",", var.firewall_rules[count.index].sources) : trimspace(item)]

  allow {
    protocol = var.firewall_rules[count.index].protocol
    ports    = var.firewall_rules[count.index].port != "-1" ? [var.firewall_rules[count.index].port] : null
  }
}

resource "google_compute_disk" "ssd_data" {
  count = length(var.ssd_data_disks) > 0 ? length(var.ssd_data_disks) * var.vm_count : 0

  name                      = "ssd-data-disk-${(count.index % length(var.ssd_data_disks)) + 1}-${var.vm_count > 1 ? format("%s-%d", var.vm_name, floor(count.index / length(var.ssd_data_disks)) + 1) : var.vm_name}"
  type                      = "pd-ssd"
  zone                      = var.zone_name
  physical_block_size_bytes = 4096
  size                      = var.ssd_data_disks[count.index % length(var.ssd_data_disks)]
  labels                    = var.labels
}
