# AWS AMIs Data-Only Terraform module

Terraform module which provides the latest AMI for most common operating systems

These types of data sources are supported:

* [AMI](https://www.terraform.io/docs/providers/aws/d/ami.html)

This module was developed by [Soluciones Company](https://www.solucionescompany.com)

<a href="https://www.solucionescompany.com/" target="_blank"><img src="https://www.solucionescompany.com/wp-content/uploads/2018/08/logo-so.jpg" alt="Soluciones Company - Impulsa tu evolucion digital" width="250" /></a>

## Terraform versions

This module was developed and tested with Terraform 0.12 only

## Usage

```hcl
module "vpc" {
  source  = "app.terraform.io/FAMRENCAR/data-amis/aws"
  
  os = "Amazon Linux 2"
}
```

## Operating systems available
This is the list of supported operating systems whose AMIs can be returned by this data module by using the **"os"** variable:

* Amazon Linux
* Amazon Linux 2
* Ubuntu Server 18.04
* CentOS 7 (requires to accept marketplace subscription)
* Windows 2016
