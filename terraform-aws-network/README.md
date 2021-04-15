# AWS Network Terraform module

Terraform module which creates essential network resources such as VPC, subnets, Internet Gateways, among others.

These types of resources are supported:

* [VPC](https://www.terraform.io/docs/providers/aws/r/vpc.html)
* [Subnet](https://www.terraform.io/docs/providers/aws/r/subnet.html)
* [Internet Gateway](https://www.terraform.io/docs/providers/aws/r/internet_gateway.html)
* [NAT Gateway](https://www.terraform.io/docs/providers/aws/r/nat_gateway.html)
* [Route](https://www.terraform.io/docs/providers/aws/r/route.html)
* [Route Table](https://www.terraform.io/docs/providers/aws/r/route_table.html)
* [Route Table Association](https://www.terraform.io/docs/providers/aws/r/route_table_association.html)

This module was developed by [Soluciones Company](https://www.solucionescompany.com)

<a href="https://www.solucionescompany.com/" target="_blank"><img src="https://www.solucionescompany.com/wp-content/uploads/2018/08/logo-so.jpg" alt="Soluciones Company - Impulsa tu evolucion digital" width="250" /></a>

## Terraform versions

This module was developed and tested with Terraform 0.12 only

## Usage

```hcl
module "network" {
  source   = "app.terraform.io/SOLUCIONES-COMPANY/network/aws"

  vpc_name                   = "demo-vpc"
  vpc_cidr_block             = "192.168.10.0/24"
  tags                       = var.tags
  enable_nat_gw              = false
  az_names                   = ["us-east-1a", "us-east-1b"]
  private_subnet_cidr_blocks = ["192.168.10.0/27", "192.168.10.32/27"]
  public_subnet_cidr_blocks  = ["192.168.10.128/27", "192.168.10.160/27"]
}
```
