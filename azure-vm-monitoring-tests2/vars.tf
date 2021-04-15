variable "PREFIX" {}
variable "AZURE_LOCATION" {
    default = "eastus"
}
variable "AZURE_TAGS" {
  type = "map"
  default = {}
}
variable "AZURE_RG" {}
variable "AZURE_VNET" {}
variable "AZURE_VNET_PREFIX" {
  type = "list"
}
variable "AZURE_SUBNET1" {}
variable "AZURE_SUBNET1_PREFIX" {}
variable "AZURE_VMIMAGE_OFFER1" {}
variable "AZURE_VMIMAGE_PUBLISHER1" {}
variable "AZURE_VMIMAGE_SKU1" {}
variable "AZURE_VMSIZE" {}
variable "BASE_NAME1" {}
variable "OS_USER" {}
variable "OS_USER_PW" {}
variable "PRIVATE_KEY" {}
variable "PUBLIC_KEY" {}
