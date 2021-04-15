module "vpc" {
  source       = "terraform-google-modules/network/google"
  version      = "~> 2.4"
  network_name = var.network_name
  project_id   = split("/", data.google_project.current.id)[1]
  routing_mode = var.routing_mode

  subnets = [
    for item in var.subnet_names :
    merge(
      {
        subnet_region = var.region_name
        subnet_name   = item
        subnet_ip     = element(var.subnet_cidrs, index(var.subnet_names, item))
        description   = element(var.subnet_descs, index(var.subnet_names, item))
      }
    )
  ]

  routes = [
    {
      name              = "route-internet-${var.network_name}"
      description       = "route through IGW to access internet"
      destination_range = "0.0.0.0/0"
      next_hop_internet = "true"
    }
  ]
}

data "google_project" "current" {
}
