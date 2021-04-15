variable "BASE_NAME" {}
variable "AZURE_RG" {}
variable "AZURE_VM_SIZE" {}
variable "AZURE_LOCATION" {
    default = "eastus"
}
variable "AZURE_SUBNET_ID" {}
variable "OS_HOSTNAME" {}
variable "OS_USER" {}
variable "OS_USER_PW" {}
variable "PRIVATE_KEY" {
    default = "id_rsa"
}
variable "PUBLIC_KEY" {
    default = "id_rsa.pub"
}
