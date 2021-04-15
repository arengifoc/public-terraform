variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}
variable "AWS_REGION" {}

variable "PUBLIC_KEY" {
  default = "mykey.pub"
}

variable "PRIVATE_KEY" {
  default = "mykey"
}

variable "INSTANCE_USERNAME" {
  default = "ec2-user"
}

variable "AMIS" {
  type = "map"
  default = {
    # Amazon Linux 2 AMI (HVM), SSD Volume Type
    us-east-1 = "ami-0922553b7b0369273"
  }
}
