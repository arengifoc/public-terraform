#!/usr/bin/env bash



# Install required OS dependencies
export PATH=/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin:/usr/local/sbin
if grep -qi amazon /etc/os-release 2> /dev/null
then
  amazon-linux-extras enable ansible2
  yum install -y python2-pip
  pip install --upgrade jinja2
fi
if which yum > /dev/null 2>&1
then
  yum install -y ansible git jq
elif which apt > /dev/null 2>&1
then
  apt update
  apt install -y ansible python git jq
fi



# Create variables file for ansible playbook
cat > /tmp/vars.yml <<EOF
---
%{ for key, value in vault_vars ~}
${key}: ${value}
%{ endfor ~}
EOF



# Populate inventory file
cat > /tmp/hosts <<EOF
[vault]
%{ for ip in vault_ips ~}
vault${index(vault_ips, ip)+1} ansible_host=${ip}
%{ endfor ~}
EOF



# Create $HOME/.ssh if it does not exist
[ ! -d /home/${bastion_ssh_user}/.ssh ] && mkdir -p /home/${bastion_ssh_user}/.ssh



# SSH config for getting easy access to vault nodes
cat >> /home/${bastion_ssh_user}/.ssh/config <<EOF
%{ for ip in vault_ips ~}
Host ${ip}
User ${vault_ssh_user}

%{ endfor ~}
EOF



# SSH private key configuration
cat >> /home/${bastion_ssh_user}/.ssh/id_rsa <<EOF
${privkey}
EOF



# Adjust permissions on $HOME/.ssh directory
chmod -R go= /home/${bastion_ssh_user}/.ssh
chown -R ${bastion_ssh_user} /home/${bastion_ssh_user}/.ssh
