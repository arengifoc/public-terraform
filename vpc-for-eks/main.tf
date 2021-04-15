# Configuracion de estado remoto para este proyecto
terraform {
  backend "s3" {
    bucket = "sysadmin-company-arengifoc-terraform-states"
    key    = "dev/vpc-for-eks/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  profile = var.AWS_PROFILE
  region  = var.AWS_REGION
}

# Obtener info de las AZs disponibles de la region
data "aws_availability_zones" "azs" {
  state = "available"
}

# VPC para EKS
resource "aws_vpc" "vpc-eks" {
  cidr_block = "${var.CIDR_BASE}.${var.CIDR_START}.0/${var.CIDR_MASK}"
  tags = {
    Name                                            = "VPC-${var.TAG_NAME_SUFFIX}"
    Owner                                           = var.TAG_OWNER
    Description                                     = var.TAG_DESCRIPTION
    Comment                                         = var.TAG_COMMENT
    TerraformProject                                = var.TAG_TERRAFORM_PROJECT
    "kubernetes.io/cluster/${var.EKS_CLUSTER_NAME}" = "shared"
  }
}

# Subnets
resource "aws_subnet" "subnets-eks" {
  count             = var.SUBNET_COUNT
  availability_zone = data.aws_availability_zones.azs.names[count.index]
  cidr_block        = "${var.CIDR_BASE}.${var.CIDR_START + count.index}.0/24"
  vpc_id            = aws_vpc.vpc-eks.id

  tags = {
    Name                                            = "SUBNET-${var.TAG_NAME_SUFFIX}-${count.index + 1}-${data.aws_availability_zones.azs.names[count.index]}"
    Owner                                           = var.TAG_OWNER
    Description                                     = var.TAG_DESCRIPTION
    Comment                                         = var.TAG_COMMENT
    TerraformProject                                = var.TAG_TERRAFORM_PROJECT
    "kubernetes.io/cluster/${var.EKS_CLUSTER_NAME}" = "shared"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw-eks" {
  vpc_id = aws_vpc.vpc-eks.id

  tags = {
    Name             = "IGW-${var.TAG_NAME_SUFFIX}"
    Owner            = var.TAG_OWNER
    Description      = var.TAG_DESCRIPTION
    Comment          = var.TAG_COMMENT
    TerraformProject = var.TAG_TERRAFORM_PROJECT
  }
}

# Route
resource "aws_route_table" "rtable-eks" {
  vpc_id = aws_vpc.vpc-eks.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-eks.id
  }

  tags = {
    Name             = "RTABLE-${var.TAG_NAME_SUFFIX}-public"
    Owner            = var.TAG_OWNER
    Description      = var.TAG_DESCRIPTION
    Comment          = var.TAG_COMMENT
    TerraformProject = var.TAG_TERRAFORM_PROJECT
  }
}

# Asociacion de route table
resource "aws_route_table_association" "rtable-association-eks" {
  count          = var.SUBNET_COUNT
  subnet_id      = aws_subnet.subnets-eks[count.index].id
  route_table_id = aws_route_table.rtable-eks.id
}

# Security Group para EKS
resource "aws_security_group" "sg-eks" {
  name        = "SG-${var.TAG_NAME_SUFFIX}"
  description = "SG para comunicacion de cluster con nodos worker"
  vpc_id      = aws_vpc.vpc-eks.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name             = "SG-master-${var.TAG_NAME_SUFFIX}"
    Owner            = var.TAG_OWNER
    Description      = var.TAG_DESCRIPTION
    Comment          = var.TAG_COMMENT
    TerraformProject = var.TAG_TERRAFORM_PROJECT
  }
}

# Regla de entrada HTTPS para el security group
resource "aws_security_group_rule" "sg-eks-https-ingress" {
  cidr_blocks       = var.MY_PUBLIC_IPS
  description       = "Permitir comunicacion al API Server"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  security_group_id = aws_security_group.sg-eks.id
  type              = "ingress"
}

