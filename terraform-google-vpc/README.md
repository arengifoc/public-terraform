# Google VPC Terraform module

Terraform module which creates a network and subnets in GCP

These types of resources are supported:

* [](https://www.terraform.io/docs/providers/google/r/compute_instance.html)
* [Compute Firewall](https://www.terraform.io/docs/providers/google/r/compute_firewall.html)
* [Compute Disk](https://www.terraform.io/docs/providers/google/r/compute_disk.html)

This module was developed by [Soluciones Company](https://www.solucionescompany.com)

<a href="https://www.solucionescompany.com/" target="_blank"><img src="https://www.solucionescompany.com/wp-content/uploads/2018/08/logo-so.jpg" alt="Soluciones Company - Impulsa tu evolucion digital" width="250" /></a>

## Terraform versions

This module was developed and tested with Terraform 0.12 only

## Usage

```hcl
module "vpc" {
  source  = "app.terraform.io/SOLUCIONES-COMPANY/vpc/google"
  version = "~> 1.0"

  region_name  = "us-east1"
  network_name = "my-demo-network"
  subnet_names = ["subnet1", "subnet2"]
  subnet_cidrs = ["172.23.19.0/24", "172.23.22.0/24"]
  subnet_descs = ["First subnet", "Second subnet"]
}
```
