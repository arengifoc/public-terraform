# Google VM Terraform module

Terraform module which creates a VM instance in GCP

These types of resources are supported:

* [Compute Instance](https://www.terraform.io/docs/providers/google/r/compute_instance.html)
* [Compute Firewall](https://www.terraform.io/docs/providers/google/r/compute_firewall.html)
* [Compute Disk](https://www.terraform.io/docs/providers/google/r/compute_disk.html)

This module was developed by [Soluciones Company](https://www.solucionescompany.com)

<a href="https://www.solucionescompany.com/" target="_blank"><img src="https://www.solucionescompany.com/wp-content/uploads/2018/08/logo-so.jpg" alt="Soluciones Company - Impulsa tu evolucion digital" width="250" /></a>

## Terraform versions

This module was developed and tested with Terraform 0.12 only

## Usage

```hcl
module "vpc" {
  source  = "app.terraform.io/FAMRENCAR/vault-cluster/aws"

  vm_count       = 1
  vm_name        = "bastion"
  zone_name      = "us-east1-c"
  machine_type   = "n2-standard-2"
  boot_disk_size = 50
  image_family   = "windows-2019"
  image_project  = "windows-cloud"
  network        = "mynetwork"
  subnetwork     = "mynetwork-subnet1"
  private_ips    = ["10.10.1.10"]
  public_ips     = ["auto"]
  labels         = var.labels

  firewall_rules = [
    {
      rule_name = "fw-ingress-rdp"
      protocol  = "tcp"
      port      = "3389"
      sources   = "0.0.0.0/0"
    },
    {
      rule_name = "fw-ingress-icmp"
      protocol  = "icmp"
      port      = "-1"
      sources   = "10.10.0.0/24,10.10.3.0/24"
    }
  ]
}
```
