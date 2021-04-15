provider "aws" {
  access_key = "*"
  secret_key = "*"
  region = "us-east-1"
}

resource "aws_instance" "vm-prueba01" {
  # AMI de Amazon Linux 2 AMI (HVM), SSD Volume Type en N. Virginia
  ami = "ami-035be7bafff33b6b6"

  # Tamaño de instancia EC2
  instance_type = "t2.nano"
}
