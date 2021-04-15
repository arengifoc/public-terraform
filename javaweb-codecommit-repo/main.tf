# remote state using s3
terraform {
  backend "s3" {
    bucket = "sysadmin-company-arengifoc-terraform-states"
    key    = "dev/javaweb-codecommit-repo/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  profile = var.AWS_PROFILE
  region  = var.REGION
}

resource "aws_codecommit_repository" "repo" {
  repository_name = var.REPOSITORY_NAME
  description     = "Repo para proyecto Java Web integrado con Beanstalk"
  default_branch  = var.DEFAULT_BRANCH
  tags = {
    Owner = var.TAG_OWNER
  }
}

output "repo_url_http" {
  value       = aws_codecommit_repository.repo.clone_url_http
  description = "URL SSH de repositorio"
}
