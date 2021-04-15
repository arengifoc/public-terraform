output "s3_bucket" {
  value = aws_s3_bucket.s3_bucket.id
}

output "dynamodb_table" {
  value = aws_dynamodb_table.dynamodb_table.id
}
