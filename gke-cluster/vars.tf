variable "CREDS_FILE" {
  type        = string
  description = "Credentials file"
  default     = "account.json"
}

variable "GCP_REGION" {
  type        = string
  description = "Desired region for resources"
  default     = "us-east1"
}

variable "GCP_PROJECT" {
  type        = string
  description = "Desired project to hold resources"
}

variable "GKE_CLUSTER_NAME" {
  type        = string
  description = "GKE cluster name"
}

variable "GKE_MASTER_USER" {
  type        = string
  description = "GKE master username"
}

variable "GKE_MASTER_PASSWORD" {
  type        = string
  description = "GKE master password"
}

variable "NODE_POOL" {
  type        = string
  description = "Node pool"
  default     = "my-node-pool"
}

variable "MACHINE_TYPE" {
  type        = string
  description = "Machine type for worker nodes"
  default     = "f1-micro"
}

variable "GKE_NODE_COUNT" {
  type        = number
  description = "Number of nodes per zone within a pool"
}
