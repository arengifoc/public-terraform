provider "google" {
  region      = "us-east1"
  project     = "poc-sap-gcp-2020"
  credentials = file("account.json")
}

module "vpc" {
  source       = "../../../../terraform-google-vpc/"
  region_name  = "us-east1"
  network_name = "demonet"
  subnet_names = ["subnet1", "subnet2"]
  subnet_cidrs = ["172.23.19.0/24", "172.23.22.0/24"]
  subnet_descs = ["First subnet", "Second subnet"]
}

output "subnets_names" {
    value = module.vpc.subnets_names
}

output "subnets_cidrs" {
    value = module.vpc.subnets_cidrs
}

output "network" {
    value = module.vpc.network_name
}