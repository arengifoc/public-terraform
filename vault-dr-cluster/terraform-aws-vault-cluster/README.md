# AWS Vault Cluster Terraform module

Terraform module which creates the infrastructure for Vault Cluster in AWS.

These types of resources are supported:

* [EC2 instance](https://www.terraform.io/docs/providers/aws/r/instance.html)
* [Security Group](https://www.terraform.io/docs/providers/aws/r/security_group.html)
* [Load Balancer](https://www.terraform.io/docs/providers/aws/r/lb.html)
* [KMS Key](https://www.terraform.io/docs/providers/aws/r/kms_key.html)
* [IAM User](https://www.terraform.io/docs/providers/aws/r/iam_user.html)
* [IAM Policy](https://www.terraform.io/docs/providers/aws/r/iam_policy.html)

This module was developed by [Soluciones Company](https://www.solucionescompany.com)

<a href="https://www.solucionescompany.com/" target="_blank"><img src="https://www.solucionescompany.com/wp-content/uploads/2018/08/logo-so.jpg" alt="Soluciones Company - Impulsa tu evolucion digital" width="250" /></a>

## Terraform versions

This module was developed and tested with Terraform 0.12 only

## Usage

```hcl
module "vpc" {
  source  = "app.terraform.io/FAMRENCAR/vault-cluster/aws"
  
  vpc_id                 = "vpc-xxxxxxxx"
  bastion_ssh_cidr_block = "0.0.0.0/0"
  consul_instance_type   = "t3a.micro"
  vault_instance_type    = "t3a.micro"
  create_kms_key         = false
  iam_vault_user         = "vaultuser"
  ca_cert_file           = file("${path.module}/ca-cert.pem")
  server_cert_file       = file("${path.module}/vault.solucionescompany.com-cert.pem")
  server_key_file        = file("${path.module}/vault.solucionescompany.com-key.pem")
  keypair_public         = file("${path.module}/keypair.pub")

  network_settings = [
    {
      type       = "private"
      subnet_id  = "subnet-xxxxxxxx"
      consul_ips = ["172.23.1.20"]
      vault_ips  = ["172.23.1.30"]
    },
    {
      type       = "private"
      subnet_id  = "subnet-xxxxxxxx"
      consul_ips = ["172.23.2.20"]
      vault_ips  = ["172.23.2.30"]
    },
    {
      type       = "private"
      subnet_id  = "subnet-xxxxxxxx"
      consul_ips = ["172.23.3.20"]
      vault_ips  = []
    },
    {
      type       = "public"
      subnet_id  = "subnet-xxxxxxxx"
      consul_ips = []
      vault_ips  = []
    },
    {
      type       = "public"
      subnet_id  = "subnet-xxxxxxxx"
      consul_ips = []
      vault_ips  = []
    },
    {
      type       = "public"
      subnet_id  = "subnet-xxxxxxxx"
      consul_ips = []
      vault_ips  = []
    }
  ]
```

## Vault with auto-unseal using AWS KMS

By default this module...
