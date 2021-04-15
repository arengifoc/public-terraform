variable "PREFIX" {}
variable "AZURE_LOCATION" {
    default = "eastus"
}
variable "AZURE_TAGS" {
  type = "map"
  default = {}
}
variable "AZURE_RG" {}
variable "AZURE_VMIMAGE_OFFER1" {}
variable "AZURE_VMIMAGE_PUBLISHER1" {}
variable "AZURE_VMIMAGE_SKU1" {}
variable "AZURE_VMIMAGE_OFFER2" {}
variable "AZURE_VMIMAGE_PUBLISHER2" {}
variable "AZURE_VMIMAGE_SKU2" {}
variable "AZURE_VMSIZE" {}
variable "BASE_NAME1" {}
variable "BASE_NAME2" {}
variable "IPADDR1" {}
variable "IPADDR2" {}
variable "OS_USER" {}
variable "OS_USER_PW" {}
variable "PRIVATE_KEY" {}
variable "PUBLIC_KEY" {}
