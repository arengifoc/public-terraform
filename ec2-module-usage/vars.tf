variable "aws_region" {
  type = string
}

variable "desired_os" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "vpc_name" {
  type = string
}

variable "subnet_name" {
  type = string
}

variable "security_group_names" {
  type = list(string)
}


variable "tag_name" {
  type = string
}

variable "tag_owner" {
  type = string
}

variable "tag_group" {
  type = string
}

variable "tag_project" {
  type = string
}

variable "tag_tf_project" {
  type = string
}

variable "instance_count" {
  type = number
}
