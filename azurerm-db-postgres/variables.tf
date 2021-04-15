variable "rg_name" {}
variable "postgres-server-name" {}
variable "postgres-sku" {}
variable "postgres-admin-username" {}
variable "postgres-admin-password" {}
variable "postgres-engine-version" {}
variable "postgres-dbs" { type = list(string) }
variable "tags" {
  type    = map(string)
  default = {}
}
