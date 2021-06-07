#!/bin/bash
TF_VERSION="0.15.5"
apt-get update
apt-get install -y tmux unzip curl python3-pip apt-transport-https ca-certificates software-properties-common
curl -s -o /tmp/awscliv2.zip https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip
curl -s -o /tmp/terraform.zip https://releases.hashicorp.com/terraform/$TF_VERSION/terraform_${TF_VERSION}_linux_amd64.zip
curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
curl -sLo /usr/local/bin/kops https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64
unzip -q awscliv2.zip -d /tmp
/tmp/aws/install
unzip -q /tmp/terraform.zip -d /usr/local/bin
pip3 install --upgrade pip
rm -f /tmp/terraform.zip /tmp/awscliv2.zip
add-apt-repository --yes ppa:ansible/ansible
cat > /etc/apt/sources.list.d/kubernetes.list << EOF
deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main
EOF
apt-get update
apt-get install -y kubectl ansible
chmod +x /usr/local/bin/kops
