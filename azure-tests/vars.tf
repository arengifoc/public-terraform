variable "PREFIX" {}
variable "AZURE_RG" {}
variable "OS_HOSTNAME" {}
variable "OS_USER" {}
variable "OS_USER_PW" {}
variable "AZURE_LOCATION" {
    default = "eastus"
}
variable "private_key" {
    default = "id_rsa"
}
