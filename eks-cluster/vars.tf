variable "AWS_PROFILE" {
  type = string
}

variable "AWS_REGION" {
  type    = string
  default = "us-east-1"
}

variable "S3_BUCKETS_FOR_IMPORTED_REMOTE_STATES" {
  type = map(object({
    bucket = string
    key    = string
    region = string
  }))
  description = "Lista de buckets usados en los estados remotos importados"
}

variable "TAG_OWNER" {
  type = string
}

variable "TAG_DESCRIPTION" {
  type = string
}

variable "TAG_TERRAFORM_PROJECT" {
  type    = string
  default = "eks-cluster"
}

variable "TAG_COMMENT" {
  type    = string
  default = "Creado usando IaC con Terraform"
}

variable "EKS_INSTANCE_TYPE" {
  type        = string
  description = "Tamaño de instancia EC2 para los workers"
}

variable "EKS_DES_WORKERS" {
  type        = number
  description = "Cantidad de workers deseados en el autoscaling group"
}

variable "EKS_MAX_WORKERS" {
  type        = number
  description = "Cantidad de workers maximos en el autoscaling group"
}

variable "EKS_MIN_WORKERS" {
  type        = number
  description = "Cantidad de workers minimos en el autoscaling group"
}

variable "LAUNCH_TEMPLATE_VERSION" {
  type        = number
  description = "Version del launch template a utilizar"
}
