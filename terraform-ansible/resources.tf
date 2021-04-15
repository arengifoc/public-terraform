resource "aws_key_pair" "KP-ssh-cnvareng" {
        key_name = "KP-ssh-cnvareng"
        public_key = "${file("${var.PUBLIC_KEY}")}"
}

resource "aws_security_group" "SG_default" {
        name        = "SG_default"
        description = "Permitir trafico SSH y RDP entrante"
        ingress {
                from_port   = 22
                to_port     = 22
                protocol    = "tcp"
                cidr_blocks = ["0.0.0.0/0"]
        }   

        egress {
                from_port       = 0 
                to_port         = 0 
                protocol        = "-1"
                cidr_blocks     = ["0.0.0.0/0"]
        }   

        tags {
            Name = "SG_default"
        }   
}

resource "aws_instance" "vm-linuxtest" {
  # AMI (imagen de SO) de Ubuntu Server 18.04 LTS (HVM), SSD Volume Type en
  # la region North Virginia
  ami = "ami-0ac019f4fcb7cb7e6"

  instance_type = "t2.nano"
  key_name = "${aws_key_pair.KP-ssh-cnvareng.id}"
  vpc_security_group_ids = ["${aws_security_group.SG_default.id}"]

  tags {
    Name = "vm-linuxtest"
  }

  # Parametros de conexion a la instancia
  connection {
      user = "${var.OS_USER}"
      private_key = "${file("${var.PRIVATE_KEY}")}"
  }

  # Solo si es Ubuntu, instalar el paquete python
  provisioner "remote-exec" {
      inline = [
          "if [ -f /etc/debian_version ]; then sleep 30 ; sudo apt-get update ; sudo apt-get install -y python ; fi",
      ]
  }

  # Localmente, ejecutar ansible hacia la IP publica de la instancia recien creada
  provisioner "local-exec" {
      command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ${aws_instance.vm-linuxtest.public_ip}, -u ${var.OS_USER} playbook.yml"
  }
}
