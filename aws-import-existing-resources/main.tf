resource "aws_instance" "import-vm01" {
  ami           = "ami-02da3a138888ced85"
  instance_type = "t2.nano"

  tags = {
    Name = "vmlnx01"
  }
}

resource "aws_instance" "tf-vm02" {
  ami           = "ami-12da3a138888ced86"
  instance_type = "t2.small"

  tags = {
    Name = "vmlnx02"
  }

  lifecycle {
    #prevent_destroy = true
    ignore_changes = ["ami"]
  }
}

resource "aws_vpc" "import-vpc01" {
  cidr_block = "10.93.34.0/24"

  tags = {
    Name = "vpc-test"
  }
}
