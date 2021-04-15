data "aws_vpc" "selected" {
  count = "${1-var.crear_vpc}"
  filter {
    name   = "tag:Name"
    values = ["${var.vpc_name}"]
  }
}

data "aws_subnet" "selected" {
  filter {
    name   = "tag:Name"
    values = ["${var.subnet_name}"]
  }

  vpc_id = "${data.aws_vpc.selected.id}"
}

output "subnet_id" {
  value = "${data.aws_subnet.selected.id}"
}

#resource "aws_key_pair" "new" {
  #key_name_prefix = "${var.instance_name}"
  #public_key = "${file(var.public_ssh_key)}"
#}
