#!/bin/bash
if [ ! -f /etc/os-release ] || ! which systemctl > /dev/null 2>&1
then
  echo "This OS isn't supported at this time"
  exit 1
fi

if grep -q "^NAME=\"Amazon Linux\"" /etc/os-release
then
  yum install -y docker jq python3 python3-pip
elif grep -q "^NAME=\"CentOS Linux\"" /etc/os-release
then
  yum install -y python3 python3-pip yum-utils epel-release
  yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
  yum install -y docker-ce docker-ce-cli containerd.io jq
elif grep -q "^NAME=\"Ubuntu\"" /etc/os-release
then
  apt-get update
  apt-get install -y jq python3-pip python3 software-properties-common apt-transport-https ca-certificates curl gnupg-agent
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
  add-apt-repository --yes "deb [arch=amd64] https://download.docker.com/linux/ubuntu `lsb_release -cs` stable"
  apt-get update
  apt-get install -y docker-ce docker-ce-cli containerd.io
fi

# Enable and start Docker
systemctl enable docker
systemctl start docker