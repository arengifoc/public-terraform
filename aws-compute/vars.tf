# Definicion de variables sin valor predeterminado. Es obligatorio
# darles un valor especifico, a traves de otro archivo.
variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}
variable "OS_USER" {}
variable "PRIVATE_KEY" {}
variable "PUBLIC_KEY" {}

# Definicion de variables con valor predeterminado. Es opcional darles
# un valor especifico en otro archivo, pues toma el valor por defecto.
variable "AWS_REGION" {
    default = "us-east-1"
}
