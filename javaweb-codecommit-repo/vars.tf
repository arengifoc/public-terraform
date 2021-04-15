variable "AWS_PROFILE" {
  type        = string
  description = "Perfil AWS CLI elegido"
}

variable "REGION" {
  type        = string
  description = "Region elegida"
  default     = "us-east-1"
}

variable "TAG_OWNER" {
  type        = string
  description = "Usuario al que pertenece del recurso"
}

variable "REPOSITORY_NAME" {
  type        = string
  description = "Nombre de repositorio Git"
}

variable "DEFAULT_BRANCH" {
  type        = string
  description = "Branch por defecto"
}

