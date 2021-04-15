#!/usr/bin/env bash
GIT_REPO="https://${tpl_git_username}:${tpl_git_token}@${tpl_git_repository_path}"
LOCAL_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
VPC_MATCH_HOST=${tpl_vpc_match_host}
OS_ADMIN_USER=${tpl_os_admin_user}
OS_ADMIN_PASSWORD=${tpl_os_admin_password}
CONSUL_NODES=${tpl_consul_nodes}
VAULT_NODES=${tpl_vault_nodes}
CONSUL_DC=${tpl_consul_dc}
CONSUL_VERSION=${tpl_consul_version}
VAULT_VERSION=${tpl_vault_version}
VAULT_TLS_DISABLE=${tpl_vault_tls_disable}
VAULT_HOSTNAME=${tpl_vault_hostname}
VAULT_AWS_REGION=${tpl_aws_region}
LOCAL_NODENAME=$(echo $VAULT_NODES","$CONSUL_NODES | tr , '\n' | grep $LOCAL_IP | cut -d / -f 1)

VAULT_AWS_ACCESS_KEY=${tpl_aws_access_key}
VAULT_AWS_SECRET_KEY=${tpl_aws_secret_key}
VAULT_AWS_KMS_KEY_ID=${tpl_aws_kms_key_id}

VAULT_CA_CERT_FILE="${tpl_ca_cert_file}"
VAULT_SERVER_CERT_FILE="${tpl_server_cert_file}"
VAULT_SERVER_KEY_FILE="${tpl_server_key_file}"

# Temporarily save certificate files under /tmp
[ -n "$VAULT_CA_CERT_FILE" ] && echo "$VAULT_CA_CERT_FILE" | tee /tmp/ca-cert.pem
[ -n "$VAULT_SERVER_CERT_FILE" ] && echo "$VAULT_SERVER_CERT_FILE" | tee /tmp/$${VAULT_HOSTNAME}-cert.pem
[ -n "$VAULT_SERVER_KEY_FILE" ] && echo "$VAULT_SERVER_KEY_FILE" | tee /tmp/$${VAULT_HOSTNAME}-key.pem

if [[ $LOCAL_NODENAME == *"consul"* ]]
then
  NODETYPE="consul_nodename"
else
  NODETYPE="vault_nodename"
fi

if grep -qi amazon /etc/os-release 2> /dev/null
then
  amazon-linux-extras enable ansible2
  yum install -y python2-pip jq
  pip install --upgrade jinja2
fi

if which dpkg > /dev/null
then
  apt install -y git ansible python jq
else
  yum install -y git ansible
fi

mkdir /tmp/roles
cd /tmp/roles
git clone $GIT_REPO

# Manually create the ansible playbook file
cat > /tmp/site.yml <<EOF
---
- hosts: localhost
  gather_facts: yes
  become: yes
  vars:
    $NODETYPE: $LOCAL_NODENAME
    vpc_match_host: $VPC_MATCH_HOST
    os_admin_user: $OS_ADMIN_USER
    os_admin_password: $OS_ADMIN_PASSWORD
    consul_dc: $CONSUL_DC
    consul_version: $CONSUL_VERSION
    vault_version: $VAULT_VERSION
    vault_tls_disable: $VAULT_TLS_DISABLE
    vault_hostname: $VAULT_HOSTNAME
    aws_region: $VAULT_AWS_REGION
$(
    if [ -n "$VAULT_CA_CERT_FILE" ] && [ -n "$VAULT_SERVER_CERT_FILE" ] && [ -n "$VAULT_SERVER_KEY_FILE" ]
    then
      echo "    ca_cert_file: /tmp/ca-cert.pem"
      echo "    server_cert_file: /tmp/$${VAULT_HOSTNAME}-cert.pem"
      echo "    server_key_file: /tmp/$${VAULT_HOSTNAME}-key.pem"
    fi
)
$(
    if [ -n "$VAULT_AWS_ACCESS_KEY" ] && [ -n "$VAULT_AWS_SECRET_KEY" ] && [ -n "$VAULT_AWS_KMS_KEY_ID" ]
    then
      echo "    aws_access_key: $VAULT_AWS_ACCESS_KEY"
      echo "    aws_secret_key: $VAULT_AWS_SECRET_KEY"
      echo "    aws_kms_key_id: $VAULT_AWS_KMS_KEY_ID"
    fi
)
    consul_nodes:
$(
    IFS=","
    for pair in $CONSUL_NODES
    do
    echo "      - name: $(echo $pair | cut -d / -f 1)"
    echo "        ip: $(echo $pair | cut -d / -f 2)"
    done
    unset IFS
)
    vault_nodes:
$(
    IFS=","
    for pair in $VAULT_NODES
    do
    echo "      - name: $(echo $pair | cut -d / -f 1)"
    echo "        ip: $(echo $pair | cut -d / -f 2)"
    done
    unset IFS
)
  tasks:
    - name: Incluir rol de despliegue de Vault y Consul
      include_role:
        name: ansible-role-vault-cluster
EOF

cd /tmp
ansible-playbook site.yml
rm -rf /tmp/roles /tmp/site.yml /tmp/*pem
