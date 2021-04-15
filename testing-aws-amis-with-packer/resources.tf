# Creacion de un Security Group "KP_default". Permite el acceso SSH y RDP desde el
# exterior y brinda salida libre a Internet
resource "aws_security_group" "SG_default" {
        # Nombre del Security Group
        name        = "SG_default"

        # Descripcion del Security Group
        description = "Permitir trafico SSH y RDP entrante"

        # Reglas de entrada del exterior
        ingress {
                from_port   = 22
                to_port     = 22
                protocol    = "tcp"
                cidr_blocks = ["0.0.0.0/0"]
        }
        ingress {
                from_port   = 3389
                to_port     = 3389
                protocol    = "tcp"
                cidr_blocks = ["0.0.0.0/0"]
        }

        # Reglas de salida al exterior
        egress {
                from_port       = 0
                to_port         = 0
                protocol        = "-1"
                cidr_blocks     = ["0.0.0.0/0"]
        }
        ingress {
                from_port = 8
                to_port = 0
                protocol = "icmp"
                cidr_blocks = ["0.0.0.0/0"]
        }

        # Nombre del Security Group con tags
        tags {
            Name = "SG_default"
        }
}

# Creacion de un Keypair SSH
resource "aws_key_pair" "KP-ssh" {
        key_name = "KP-ssh"
        public_key = "${file("${var.PUBLIC_KEY}")}"
}

# Creacion de una instancia EC2, con nombre interno “vm-prueba01”
resource "aws_instance" "vm-prueba01" {
  # AMI a usar
  ami = "${var.AWS_AMI_ID}"

  # Tamaño de instancia
  instance_type = "t2.nano"

  # Keypair SSH a usar
  key_name = "${aws_key_pair.KP-ssh.id}"

  # Asociar el Security Group "SG_default" creado anteriormente
  vpc_security_group_ids = ["${aws_security_group.SG_default.id}"]

  # Asignar el nombre a la VM usando tags
  tags {
    Name = "vm-lnxprueba01"
  }
}

output "lnxprueba01-ip" {
        value = "${aws_instance.vm-prueba01.public_ip}"
}
