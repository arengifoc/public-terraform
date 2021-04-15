# Create EC2 instances for vault cluster
module "vm-linux" {
  source = "git::https://gitlab.com/arengifoc/terraform-azurerm-vm.git?ref=7b17eee07eaeafcdf333cb819336cd8a20ab6620"

  vm_count           = 1
  vm_name            = var.vm-linux-name
  resource_group     = local.rg_name
  subnet_id          = module.network.subnet_ids[0]
  size               = "Standard_B1ms"
  admin_username     = "arengifo"
  ssh_public_key     = var.public_sshkey
  os_image_publisher = "Canonical"
  os_image_offer     = "UbuntuServer"
  os_image_sku       = "18.04-LTS"
  public_ip_type     = "Dynamic"
  tags               = var.tags
  custom_data = base64encode(<<EOF
#!/bin/bash
apt update
apt install -y software-properties-common
apt-add-repository --yes --update ppa:ansible/ansible
apt install -y ansible
ssh-keygen -t rsa -f ~/.ssh/id_rsa -N ""
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
cd /tmp
git clone -b sid https://gitlab.com/arengifoc/ansible-role-vault-setup.git
cd ansible-role-vault-setup
echo "vault ansible_host=${module.vm-linux.private_ip[0]}" >> hosts
ansible-playbook site.yml
EOF
)

  nsg_rules = [
    {
      name        = "in_ssh"
      description = "Allow incoming SSH traffic"
      protocol    = "tcp"
      dst_port    = "22"
      src_addr    = "*"
      priority    = 100
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
