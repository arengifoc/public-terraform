variable "AWS_REGION" {
  default = "us-east-1"
}
variable "PRIVATE_KEY" {}
variable "PUBLIC_KEY" {}
variable "OS_USER" {
  type = "map"
}
variable "AMIS" {
  type = "map"
}
