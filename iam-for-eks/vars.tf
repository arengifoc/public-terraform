variable "AWS_PROFILE" {
  type = string
}

variable "AWS_REGION" {
  type    = string
  default = "us-east-1"
}

variable "IAM_ROLE_NAME" {
  type = string
}

variable "TAG_OWNER" {
  type = string
}

variable "TAG_DESCRIPTION" {
  type = string
}

variable "TAG_COMMENT" {
  type = string
  default = "Creado usando IaC con Terraform"
}

variable "TAG_TERRAFORM_PROJECT" {
  type    = string
  default = "iam-for-eks"
}
