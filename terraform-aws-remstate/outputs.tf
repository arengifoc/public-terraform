output "this_s3_bucket_id" {
  description = "Name of the S3 bucket created"
  value       = aws_s3_bucket.this.id
}

output "this_dynamodb_table_id" {
  description = "Name of the DynamoDB table created"
  value       = aws_dynamodb_table.this.id
}
