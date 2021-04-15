variable "region" {
  type    = string
  default = "us-east-1"
}

variable "s3_bucket_name" {
  type        = string
  description = "Name of S3 bucket to create"
}

variable "dynamodb_table_name" {
  type        = string
  description = "Name of DynamoDB table to create"
}

#####################
# Variables de Tags #
#####################

variable "tag_name" {
  type        = string
  description = "Nombre de la(s) instancia(s)"
  default     = null
}

variable "tag_owner" {
  type        = string
  description = "Usuario al que pertenece del recurso (parte de usuario del e-mail de trabajo)"
}

variable "tag_group" {
  type        = string
  description = "Nombre del team al que pertenece el recurso"
}

variable "tag_project" {
  type        = string
  description = "Nombre del proyecto al que pertenece el recurso"
}

variable "tag_description" {
  type        = string
  description = "Descripcion del recurso"
  default     = null
}

variable "tag_comment" {
  type    = string
  default = "Creado usando IaC con Terraform"
}

variable "tag_tf_project" {
  type        = string
  description = "Nombre del proyecto Terraform"
  default     = "temp-ec2-instances"
}
