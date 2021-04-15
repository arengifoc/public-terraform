variable "s3_bucket_name" {
  description = "S3 bucket name for storing terraform state files"
  type        = string
}

variable "s3_versioning" {
  description = "Whether to enable or not S3 versioning"
  type        = bool
  default     = true
}

variable "s3_sse_algorithm" {
  description = "Algorithm used for encrypting S3 objects"
  type        = string
  default     = "AES256"
}

variable "s3_block_public" {
  description = "Whether to block public access or not"
  type        = bool
  default     = true
}

variable "dynamodb_table_name" {
  description = "DynamoDB table name for storing locking data of terraform state files"
  type        = string
  default     = "tfstate"
}

variable "tags" {
  description = "Tags to apply to all resources"
  default     = {}
}
