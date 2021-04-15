#!/usr/bin/env bash

# install dependencies
if grep -qi amazon /etc/os-release 2> /dev/null
then
  amazon-linux-extras enable ansible2
  yum install -y python2-pip
  pip install --upgrade jinja2
fi

export PATH=/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin:/usr/local/sbin
if which yum > /dev/null 2>&1
then
  yum install -y ansible git jq
elif which apt > /dev/null 2>&1
then
  apt update
  apt install -y ansible python git jq
fi

cat > /tmp/ca-cert.pem <<EOF
${ca_cert_file}
EOF

cat > /tmp/server-cert.pem <<EOF
${server_cert_file}
EOF

cat > /tmp/server-key.pem <<EOF
${server_key_file}
EOF

cat > /tmp/vars.yml <<EOF
---
%{ for key, value in consul_vars ~}
${key}: ${value}
%{ endfor ~}

%{ for key, value in vault_vars ~}
${key}: ${value}
%{ endfor ~}
ca_cert_file: /tmp/ca-cert.pem
server_cert_file: /tmp/server-cert.pem
server_key_file: /tmp/server-key.pem
EOF

cat > /tmp/hosts <<EOF
[consul]
%{ for ip in consul_ips ~}
consul${index(consul_ips, ip)+1} ansible_host=${ip}
%{ endfor ~}

[vault]
%{ for ip in vault_ips ~}
vault${index(vault_ips, ip)+1} ansible_host=${ip}
%{ endfor ~}
EOF

[ ! -d /home/${bastion_ssh_user}/.ssh ] && mkdir -p /home/${bastion_ssh_user}/.ssh
cat >> /home/${bastion_ssh_user}/.ssh/config <<EOF
%{ for ip in consul_ips ~}
Host ${ip}
User ${consul_ssh_user}

%{ endfor ~}

%{ for ip in vault_ips ~}
Host ${ip}
User ${vault_ssh_user}

%{ endfor ~}
EOF

cat >> /home/${bastion_ssh_user}/.ssh/id_rsa <<EOF
${privkey}
EOF

chmod -R go= /home/${bastion_ssh_user}/.ssh
chown -R ${bastion_ssh_user} /home/${bastion_ssh_user}/.ssh
# echo "ANSIBLE_HOST_KEY_CHECKING=False" >> /home/${bastion_ssh_user}/.bashrc
