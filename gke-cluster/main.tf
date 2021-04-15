# remote state using s3
terraform {
  backend "s3" {
    bucket = "sysadmin-company-arengifoc-terraform-states"
    key    = "dev/gke-cluster/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "google" {
  credentials = file(var.CREDS_FILE)
  project     = var.GCP_PROJECT
  region      = var.GCP_REGION
}

resource "google_container_cluster" "gkecluster" {
  name     = var.GKE_CLUSTER_NAME
  location = var.GCP_REGION

  # Trabajaremos sin el node pool definido por defecto dentro del cluster,
  # sino usando uno propio definido lineas abajo
  remove_default_node_pool = true
  initial_node_count       = 1

  # Configuracion de autenticacion
  master_auth {
    username = var.GKE_MASTER_USER
    password = var.GKE_MASTER_PASSWORD

    client_certificate_config {
      issue_client_certificate = false
    }
  }
}

# Node pool personalizado
resource "google_container_node_pool" "node_pool" {
  name       = var.NODE_POOL
  location   = var.GCP_REGION
  cluster    = google_container_cluster.gkecluster.name
  node_count = var.GKE_NODE_COUNT

  node_config {
    # Tipo de instancia a usar en los worker nodes
    machine_type = var.MACHINE_TYPE

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}
