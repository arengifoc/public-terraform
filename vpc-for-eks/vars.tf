variable "AWS_PROFILE" {
  type = string
}

variable "AWS_REGION" {
  type    = string
  default = "us-east-1"
}

variable "CIDR_BASE" {
  type = string
}

variable "CIDR_START" {
  type = number
}

variable "CIDR_MASK" {
  type = string
}

variable "TAG_NAME_SUFFIX" {
  type = string
}

variable "SUBNET_COUNT" {
  type        = number
  description = "Number of subnets for the VPC"
}

variable "TAG_OWNER" {
  type = string
}

variable "TAG_DESCRIPTION" {
  type = string
}

variable "TAG_TERRAFORM_PROJECT" {
  type    = string
  default = "vpc-for-eks"
}

variable "TAG_COMMENT" {
  type    = string
  default = "Creado usando IaC con Terraform"
}

variable "EKS_CLUSTER_NAME" {
  type        = string
  description = "Name of the EKS cluster"
}

variable "MY_PUBLIC_IPS" {
  type = list
  description = "Lista de IPs publicas de mi propiedad a las que le permito el trafico hacia el API Server de EKS"
}
