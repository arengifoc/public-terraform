# Configuracion de estado remoto para este proyecto
terraform {
  backend "s3" {
    bucket = "sysadmin-company-arengifoc-terraform-states"
    key    = "dev/eks-cluster/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  profile = var.AWS_PROFILE
  region  = var.AWS_REGION
}

# Importacion de estado remoto para proyecto vpc-for-eks
data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = var.S3_BUCKETS_FOR_IMPORTED_REMOTE_STATES["vpc-for-eks"].bucket
    key    = var.S3_BUCKETS_FOR_IMPORTED_REMOTE_STATES["vpc-for-eks"].key
    region = var.S3_BUCKETS_FOR_IMPORTED_REMOTE_STATES["vpc-for-eks"].region
  }
}

# Importacion de estado remoto para proyecto iam-for-eks
data "terraform_remote_state" "iam" {
  backend = "s3"
  config = {
    bucket = var.S3_BUCKETS_FOR_IMPORTED_REMOTE_STATES["iam-for-eks"].bucket
    key    = var.S3_BUCKETS_FOR_IMPORTED_REMOTE_STATES["iam-for-eks"].key
    region = var.S3_BUCKETS_FOR_IMPORTED_REMOTE_STATES["iam-for-eks"].region
  }
}

# Declaracion de variables locales
locals {
  cluster_name        = data.terraform_remote_state.vpc.outputs.eks-cluster-name
  kubeconfig          = <<KUBECONFIG
apiVersion: v1
clusters:
- cluster:
    server: ${aws_eks_cluster.eks-cluster.endpoint}
    certificate-authority-data: ${aws_eks_cluster.eks-cluster.certificate_authority.0.data}
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: aws
  name: aws
current-context: aws
kind: Config
preferences: {}
users:
- name: aws
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      command: aws-iam-authenticator
      args:
        - "token"
        - "-i"
        - "${aws_eks_cluster.eks-cluster.name}"
KUBECONFIG
  user_data           = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --apiserver-endpoint '${aws_eks_cluster.eks-cluster.endpoint}' --b64-cluster-ca '${aws_eks_cluster.eks-cluster.certificate_authority[0].data}' '${local.cluster_name}'
USERDATA
  config_map_aws_auth = <<CONFIGMAPAWSAUTH
apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    - rolearn: ${data.terraform_remote_state.iam.outputs.role_arn}
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
CONFIGMAPAWSAUTH
}

# Security Group para los nodos worker
resource "aws_security_group" "sg-workers" {
  name        = "SG-workers-"
  description = "SG para comunicacion entre nodos"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc-id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name"                                        = "SG-worker-${local.cluster_name}"
    "kubernetes.io/cluster/${local.cluster_name}" = "owned"
    Owner                                         = var.TAG_OWNER
    Description                                   = var.TAG_DESCRIPTION
    Comment                                       = var.TAG_COMMENT
    TerraformProject                              = var.TAG_TERRAFORM_PROJECT

  }
}

# Reglas para el security group anterior
resource "aws_security_group_rule" "sg-workers-rule-ingress-self" {
  description              = "Permite comunicacion entre los miembros del mismo security group"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.sg-workers.id
  source_security_group_id = aws_security_group.sg-workers.id
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "sg-workers-rule-ingress-cluster" {
  description              = "Permitir comunicacion hacia los workers desde los nodos master"
  from_port                = 1025
  protocol                 = "tcp"
  security_group_id        = aws_security_group.sg-workers.id
  source_security_group_id = data.terraform_remote_state.vpc.outputs.sg-id
  to_port                  = 65535
  type                     = "ingress"
}

# Creacion del cluster EKS
resource "aws_eks_cluster" "eks-cluster" {
  name     = data.terraform_remote_state.vpc.outputs.eks-cluster-name
  role_arn = data.terraform_remote_state.iam.outputs.role_arn

  vpc_config {
    security_group_ids = [data.terraform_remote_state.vpc.outputs.sg-id]
    subnet_ids         = data.terraform_remote_state.vpc.outputs.subnet-ids
  }

  tags = {
    Owner            = var.TAG_OWNER
    Description      = var.TAG_DESCRIPTION
    Comment          = var.TAG_COMMENT
    TerraformProject = var.TAG_TERRAFORM_PROJECT
  }
}

# Ubicar el AMI mas reciente para usar en los nodos worker
data "aws_ami" "ami-workers" {
  filter {
    name   = "name"
    values = ["amazon-eks-node-${aws_eks_cluster.eks-cluster.version}-v*"]
  }

  most_recent = true
  owners      = ["602401143452"]
}

# Launch template para lanzar los worker nodes
resource "aws_launch_template" "lt-workers" {
  name_prefix   = "eks-worker"
  image_id      = data.aws_ami.ami-workers.id
  instance_type = var.EKS_INSTANCE_TYPE
  # vpc_security_group_ids = [aws_security_group.sg-workers.id]
  user_data = base64encode(local.user_data)
  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size = 20
    }
  }
  iam_instance_profile {
    arn = data.terraform_remote_state.iam.outputs.instance-profile-arn
  }
  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.sg-workers.id]
  }
  tag_specifications {
    resource_type = "instance"
    tags = {
      Owner            = var.TAG_OWNER
      Description      = var.TAG_DESCRIPTION
      Comment          = var.TAG_COMMENT
      TerraformProject = var.TAG_TERRAFORM_PROJECT
    }
  }
}

# Autoscaling group que usa el launch template creado arriba
# Esto es para lanzar los nodos worker
resource "aws_autoscaling_group" "lc-workers" {
  name = "lc-eks-workers"
  launch_template {
    id      = aws_launch_template.lt-workers.id
    version = aws_launch_template.lt-workers.latest_version
  }
  desired_capacity    = var.EKS_DES_WORKERS
  max_size            = var.EKS_MAX_WORKERS
  min_size            = var.EKS_MIN_WORKERS
  vpc_zone_identifier = data.terraform_remote_state.vpc.outputs.subnet-ids

  tag {
    key                 = "Name"
    value               = "eks-worker-node-"
    propagate_at_launch = true
  }

  tag {
    key                 = "kubernetes.io/cluster/${local.cluster_name}"
    value               = "owned"
    propagate_at_launch = true
  }
}
