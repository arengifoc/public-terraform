variable "rg_name" {}
variable "subnet_name" {}
variable "net_name" {}
variable "admin_username" { default = "arengifo" }
variable "vm_name" {}
variable "vm_size" {}
variable "vm_imageid" {}
variable "disk_type" { default = "StandardSSD_LRS" }
variable "public_ip_type" { default = "Dynamic" }
variable "vm_userdata" { default = null }
variable "public_sshkey" { default = null }
variable "custom_data_template" { default = "templates/tfe.sh.tpl" }

variable "tags" {
  type    = map(string)
  default = {}
}

variable "nsg_rules" {
  type = list(map(string))
  default = [
    {
      name        = "in_ssh"
      description = "Allow incoming SSH traffic"
      protocol    = "tcp"
      dst_port    = "22"
      src_addr    = "*"
    },
    {
      name        = "in_tfe_https"
      description = "Allow incoming HTTPS traffic to TFE"
      protocol    = "tcp"
      dst_port    = "443"
      src_addr    = "*"
    },
    {
      name        = "in_tfe_setup"
      description = "Allow incoming TCP 8800 traffic"
      protocol    = "tcp"
      dst_port    = "8800"
      src_addr    = "*"
    },
    {
      name        = "out-all"
      description = "Allow all outgoing traffic"
      protocol    = "*"
      dst_addr    = "*"
      direction   = "Outbound"
    }
  ]
}
