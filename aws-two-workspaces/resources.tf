resource "aws_key_pair" "KP-ssh" {
  key_name = "KP-ssh-arengifoc-${terraform.workspace}"
  public_key = "${file("${var.PUBLIC_KEY}")}"
}

resource "aws_security_group" "SG_default" {
  name        = "SG_Default_VMtest-${terraform.workspace}"
  description = "Permitir trafico SSH entrante"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["52.170.150.149/32"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  tags {
    Name = "SG_Default_VMtest"
  }
}

resource "aws_instance" "vm-lnxtest01" {
  # Consulta a mapa de variables con los IDs de las AMIs
  ami = "${lookup(var.AMIS, "ubuntu1804")}"
  vpc_security_group_ids = ["${aws_security_group.SG_default.id}"]
  key_name = "${aws_key_pair.KP-ssh.id}"
  instance_type = "t2.nano"
  tags {
      Name = "vm_lnxtest01"
  }
}

output "ip_publica" {
  value = "${aws_instance.vm-lnxtest01.public_ip}"
}
