resource "aws_s3_bucket" "this" {
  bucket = var.s3_bucket_name

  versioning {
    enabled = var.s3_versioning
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = var.s3_sse_algorithm
      }
    }
  }

  # Common tags
  tags = var.tags
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = var.s3_block_public
  block_public_policy     = var.s3_block_public
  restrict_public_buckets = var.s3_block_public
  ignore_public_acls      = var.s3_block_public
}

# DynamoDB table for locking remote state files
resource "aws_dynamodb_table" "this" {
  name         = var.dynamodb_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = var.tags
}
