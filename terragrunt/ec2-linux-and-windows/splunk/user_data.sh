#!/bin/bash
apt-get update
apt-get install -y software-properties-common
apt-add-repository --yes --update ppa:ansible/ansible
apt-get install -y git ansible
cd /tmp
git clone https://github.com/arengifoc/public-ansible
cd /tmp/public-ansible/ansible-role-docker-swarm
cat > /tmp/site.yml <<EOF
- hosts: localhost
  connection: local
  gather_facts: no
  roles:
    - role: /tmp/public-ansible/ansible-role-docker-swarm
      vars:
        role_action: install
EOF
ansible-playbook /tmp/site.yml
docker pull splunk/splunk:latest
docker container run --name splunk -d -p 8000:8000 -p 9997:9997 -e SPLUNK_START_ARGS="--accept-license" -e "SPLUNK_PASSWORD=Splunk2021" splunk/splunk
