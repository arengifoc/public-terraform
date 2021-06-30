#!/bin/bash
apt-get update
apt-get install -y jq python3-pip python3 software-properties-common apt-transport-https ca-certificates curl gnupg-agent tmux
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository --yes "deb [arch=amd64] https://download.docker.com/linux/ubuntu `lsb_release -cs` stable"
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io
curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Enable and start Docker
systemctl enable docker containerd --now

# Configure Docker
usermod -aG docker ubuntu

cd /home/ubuntu
touch docker-compose.yml
mkdir jenkins_home
chown ubuntu:ubuntu docker-compose.yml jenkins_home

docker pull arengifoc/jenkins:v1.0.0

cat > docker-compose.yml <<EOF
version: '3'
services:
  jenkins:
    container_name: jenkins
    image: arengifoc/jenkins:v1.0.0
    ports:
      - "8080:8080"
    volumes:
      - $PWD/jenkins_home:/var/jenkins_home
    networks:
      - net
    user: jenkins
networks:
  net:
EOF

docker-compose up -d

