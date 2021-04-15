variable "region" {
  type        = string
  description = "AWS region where resources must be created"
  default     = "us-east-1"
}

variable "alb_name_prefix" {
  type        = string
  description = "Name prefix for the load balancer"
  default     = null
}

variable "sg_name_prefix" {
  type        = string
  description = "Name prefix for the security group"
  default     = null
}

variable "bucket_name_prefix" {
  type        = string
  description = "Name prefix for the S3 bucket"
  default     = null
}

variable "name_prefix" {
  type        = string
  description = "Common prefix name for resources (S3, bucket, load balancer)"
  default     = null
}


variable "is_internal" {
  type        = bool
  description = "Whether it is an internal load balancer or not"
  default     = false
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of Subnet IDs for the load balancer"
}

variable "prevent_deletion" {
  type        = bool
  description = "It prevents the resource from being deleted"
  default     = true
}

variable "force_lblogs_bucket_destroy" {
  type        = bool
  description = "It prevents deletion of all objects when attempting to remove the bucket"
  default     = false
}

variable "enable_http2" {
  type        = bool
  description = "Whether to enable HTTP v2 for the load balancer"
  default     = true
}

variable "ip_address_type" {
  type        = string
  description = "IP protocols that the load balancer should support"
  default     = "ipv4"
}

variable "idle_timeout" {
  type        = number
  description = "Maximum number of seconds that a connection in idle state if allowed before terminating it."
  default     = 60
}

variable "common_tags" {
  type        = map(string)
  description = "List of tags to apply to all resources in a form of a map"
  default     = {}
}

variable "alb_in_ports" {
  type        = list(string)
  description = "List of TCP ports to allow for incoming traffic to the load balancer"
  default     = ["443"]
}

variable "elb_account_id" {
  type = map(object({
    account_id = string
  }))
  description = "It contains the list of AWS account IDs owned by Amazon which are needed to grant permissions to access logs S3 bucket"
  default = {
    "us-east-1" = {
      account_id = "127311923021"
    }
    "us-east-2" = {
      account_id = "033677994240"
    }
    "us-west-1" = {
      account_id = "027434742980"
    }
    "us-west-2" = {
      account_id = "797873946194"
    }
    "af-south-1" = {
      account_id = "098369216593"
    }
    "ca-central-1" = {
      account_id = "985666609251"
    }
    "eu-central-1" = {
      account_id = "054676820928"
    }
    "eu-west-1" = {
      account_id = "156460612806"
    }
    "eu-west-2" = {
      account_id = "652711504416"
    }
    "eu-south-1" = {
      account_id = "635631232127"
    }
    "eu-west-3" = {
      account_id = "009996457667"
    }
    "eu-north-1" = {
      account_id = "897822967062"
    }
    "ap-east-1" = {
      account_id = "754344448648"
    }
    "ap-northeast-1" = {
      account_id = "582318560864"
    }
    "ap-northeast-2" = {
      account_id = "600734575887"
    }
    "ap-northeast-3" = {
      account_id = "383597477331"
    }
    "ap-southeast-1" = {
      account_id = "114774131450"
    }
    "ap-southeast-2" = {
      account_id = "783225319266"
    }
    "ap-south-1" = {
      account_id = "718504428378"
    }
    "me-south-1" = {
      account_id = "076674570225"
    }
    "sa-east-1" = {
      account_id = "507241528517"
    }
  }
}

variable "lblogs_prefix_path" {
  type        = string
  description = "Prefix path for storing LB access logs within a bucket"
  default     = "alblogs"
}

variable "alb_access_logs_enabled" {
  type        = bool
  default     = true
  description = "Whether to enable or not access logs in S3 bucket"
}
