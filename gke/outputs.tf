# output "cluster_username" {
#   value = google_container_cluster.this.master_auth[0].username
# }

# output "cluster_password" {
#   value = google_container_cluster.this.master_auth[0].password
# }

output "cluster_endpoint" {
  value = google_container_cluster.this.endpoint
}

output "cluster_region" {
  value = var.gcp_region
}

output "cluster_name" {
  value = "${local.prefix}-cluster"
}