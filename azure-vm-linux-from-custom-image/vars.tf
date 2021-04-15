# Definicion de variables sin valor predeterminado. Es obligatorio
# darles un valor especifico, a traves de otro archivo.
variable "OS_USER" {}
variable "OS_USER_PW" {}
variable "OS_HOSTNAME" {}
variable "PRIVATE_KEY" {}
variable "PUBLIC_KEY" {}

# Definicion de variables con valor predeterminado. Es opcional darles
# un valor especifico en otro archivo, pues toma el valor por defecto.
variable "AZURE_LOCATION" {
    default = "eastus"
}
