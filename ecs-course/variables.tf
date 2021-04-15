variable "name_prefix" {
  description = "Name prefix for several resources"
  type        = string
  default     = "acancino"
}

variable "vpc_id" {
  description = "ID of VPC where resources should be deployed"
  type        = string
  default     = "vpc-xxxxxxxx" # itdvo-sbx-persistent-vpc
}

variable "subnet_id" {
  description = "ID of subnet where resources should be deployed"
  type        = string
  default     = "subnet-xxxxxxxx" # itdvo-sbx-persistent-vpc-Private-us-west-2b
}

variable "tags" {
  description = "Tags to associate to all resources"
  type        = map(string)
  default = {
    owner   = "acancino@splunk.com"
    comment = "Temporary resource created for testing purposes"
  }
}

variable "s3_bucket_prefix" {
  description = "S3 bucket name prefix"
  type        = string
  default     = "acancino-bucket"
}

