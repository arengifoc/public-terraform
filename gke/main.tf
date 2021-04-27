locals {
  prefix = "${var.name_prefix}-${random_id.suffix.hex}"
}

provider "google" {
  project     = var.gcp_project
  region      = var.gcp_region
  credentials = var.creds_file != null ? file(var.creds_file) : "~/.ssh/${var.gcp_project}_account.json"
}

resource "google_container_cluster" "this" {
  name        = "${local.prefix}-cluster"
  location    = var.cluster_location
  description = var.cluster_description

  # Let's remove default node pool and create a custom one
  remove_default_node_pool = true
  initial_node_count       = 1

  # Auth settings
  master_auth {
    # username = "${local.prefix}-admin"
    # password = random_password.gke.result
    # username = null
    # password = null

    client_certificate_config {
      issue_client_certificate = true
    }
  }
}

# Custom node pool
resource "google_container_node_pool" "node_pool" {
  name       = "${local.prefix}-node-pool"
  location   = var.cluster_location
  cluster    = google_container_cluster.this.name
  node_count = var.gke_node_count

  autoscaling {
    min_node_count = var.min_node_count
    max_node_count = var.max_node_count
  }

  node_config {
    # Instance type for worker nodes
    machine_type = var.machine_type

    # Autoscaling settings

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}

resource "random_id" "suffix" {
  byte_length = 2
}

resource "random_password" "gke" {
  length = 16
}
