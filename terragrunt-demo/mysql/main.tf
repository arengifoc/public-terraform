resource "aws_s3_bucket" "this" {
  tags = {
    "comment" = "Demo bucket"
  }
}

output "s3_bucket_this" {
  description = "Name of S3 bucket"
  value       = aws_s3_bucket.this.id
}
