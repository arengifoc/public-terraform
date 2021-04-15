# Configuracion de estado remoto para este proyecto
terraform {
  backend "s3" {
    bucket = "sysadmin-company-arengifoc-terraform-states"
    key    = "dev/iam-for-eks/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  profile = var.AWS_PROFILE
  region  = var.AWS_REGION
}

# Rol IAM para EKS
resource "aws_iam_role" "iam-role-eks" {
  name = var.IAM_ROLE_NAME

  assume_role_policy = <<IAM_ROLE_POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
IAM_ROLE_POLICY

  tags = {
    Owner            = var.TAG_OWNER
    Description      = var.TAG_DESCRIPTION
    Comment          = var.TAG_COMMENT
    TerraformProject = var.TAG_TERRAFORM_PROJECT
  }
}

resource "aws_iam_instance_profile" "iam-instance-profile-eks" {
  name = "workers-instance-profile"
  role = aws_iam_role.iam-role-eks.name
}

resource "aws_iam_role_policy_attachment" "eks-cluster-policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.iam-role-eks.name
}

resource "aws_iam_role_policy_attachment" "eks-service-policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.iam-role-eks.name
}
