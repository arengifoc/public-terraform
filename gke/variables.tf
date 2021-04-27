variable "gcp_project" {
  description = "Desired project to hold resources"
  type        = string
}

variable "creds_file" {
  description = "Credentials file"
  type        = string
  default     = null
}

variable "gcp_region" {
  description = "Desired region for resources"
  type        = string
  default     = "us-east1"
}

variable "name_prefix" {
  description = "GKE cluster name"
  type        = string
  default     = "arengifoc"
}

variable "cluster_location" {
  description = "Defines where to deploy the cluster nodes. If a region is specified, the clusters becomes multi-zonal. Otherwise, if a zone is specified, it will be a zonal cluster"
  type        = string
  default     = "us-east1-b"
}

variable "cluster_description" {
  description = "An optional description for the cluster"
  type        = string
  default     = null
}

variable "machine_type" {
  type        = string
  description = "Machine type for worker nodes"
  default     = "g1-small"
}

variable "gke_node_count" {
  description = "Number of nodes per zone within a pool"
  type        = number
  default     = 1
}

variable "min_node_count" {
  description = "Minimum number of nodes in the node pool"
  type        = number
  default     = 1
}

variable "max_node_count" {
  description = "Maximum number of nodes in the node pool"
  type        = number
  default     = 1
}
