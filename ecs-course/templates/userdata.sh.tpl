#!/bin/bash
amazon-linux-extras install -y ecs
yum install -y aws-cli
systemctl enable --now --no-block ecs.service
aws s3 cp s3://${bucket_name}/ecs.config /etc/ecs/ecs.config