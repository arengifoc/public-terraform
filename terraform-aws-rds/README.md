# AWS RDS Terraform module

Terraform module which creates MySQL or PostgreSQL RDS instances

These types of resources are supported:

* [DB Instance](https://www.terraform.io/docs/providers/aws/r/db_instance.html)
* [DB Option Group](https://www.terraform.io/docs/providers/aws/r/db_instance.html)
* [DB Parameter Group](https://www.terraform.io/docs/providers/aws/r/db_parameter_group.html)
* [DB Subnet Group](https://www.terraform.io/docs/providers/aws/r/db_subnet_group.html)
* [Security Group](https://www.terraform.io/docs/providers/aws/r/security_group.html)
* [Security Group Rule](https://www.terraform.io/docs/providers/aws/r/security_group_rule.html)

This module was developed by [Soluciones Company](https://www.solucionescompany.com)

<a href="https://www.solucionescompany.com/" target="_blank"><img src="https://www.solucionescompany.com/wp-content/uploads/2018/08/logo-so.jpg" alt="Soluciones Company - Impulsa tu evolucion digital" width="250" /></a>

## Terraform versions

This module was developed and tested with Terraform 0.12 only

## Usage

```hcl
module "network" {
  source  = "app.terraform.io/SOLUCIONES-COMPANY/rds/aws"

  identifier           = "dbdemo"
  subnet_ids           = ["subnet-xxxxxxxx","subnet-xxxxxxxx"]
  master_password      = "SecretPassword"
  master_username      = "myadmin"
  engine               = "postgres"
  engine_version       = "9.6.18"
  engine_major_version = "9.6"
  allowed_cidr_block   = "10.0.0.0/16"
}
```
