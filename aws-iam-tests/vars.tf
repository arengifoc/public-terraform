#
#
# Agregue esta linea de comentario el 18-feb a las 17:35
#
#
variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}
variable "AWS_REGION" {
    default = "us-east-1"
}
variable "usuarios" {
  type = "list"
}

variable PRUEBA {}
variable ESTADO {}
