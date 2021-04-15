provider "aws" {
  region = var.region
}

# remote state using s3
terraform {
  backend "s3" {
    bucket         = "company-peru-terraform-states"
    key            = "global/s3-terraform-states/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "company-peru-terraform-states-locking"
  }
}

# Bucket for remote state files
resource "aws_s3_bucket" "s3_bucket" {
  # bucket name
  bucket = var.s3_bucket_name

  # prevent accidental deletion of this bucket
  lifecycle {
    prevent_destroy = false
  }

  # enable versioning
  versioning {
    enabled = true
  }

  # enable encryption
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  # Common tags
  tags = {
    Owner     = var.tag_owner
    Group     = var.tag_group
    Project   = var.tag_project
    TFProject = var.tag_tf_project
  }
}

# DynamoDB table for locking remote state files
resource "aws_dynamodb_table" "dynamodb_table" {
  name         = var.dynamodb_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  # Common tags
  tags = {
    Owner     = var.tag_owner
    Group     = var.tag_group
    Project   = var.tag_project
    TFProject = var.tag_tf_project
  }
}

resource "aws_s3_bucket_public_access_block" "bucket_acl" {
  bucket = aws_s3_bucket.s3_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}
