# Creacion de instancia windows con provisioner tipo file, remote-exec y local-exec, integrado con ansible
resource "aws_key_pair" "KP-arengifo" {
        key_name = "KP-arengifo"
        public_key = "${file("${var.PUBLIC_KEY}")}"
}

resource "aws_security_group" "SG_default_RDP_WinRM" {
        name        = "SG_default_RDP_WinRM"
        description = "Permitir trafico RDP y WinRM entrante"
        ingress {
                from_port   = 3389
                to_port     = 3389
                protocol    = "tcp"
                cidr_blocks = ["0.0.0.0/0"]
        }
        ingress {
                from_port   = 5986
                to_port     = 5986
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
            Name = "SG_default_RDP_WinRM"
        }
}

resource "aws_instance" "vm-wintest01" {
    # Consulta a mapa de variables con los IDs de las AMIs
    ami = "${lookup(var.AMIS_WINDOWS, var.AWS_REGION)}"
    vpc_security_group_ids = ["${aws_security_group.SG_default_RDP_WinRM.id}"]
    key_name = "${aws_key_pair.KP-arengifo.id}"
    instance_type = "t2.medium"
    tags {
        Name = "vm_wintest01"
    }
    connection {
        user = "${var.OS_USER}"
        private_key = "${file("${var.PRIVATE_KEY}")}"
    }
    provisioner "remote-exec" {
        inline = [
            "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init to finish...' ; sleep 1; done",
            "sudo apt-get update",
            "sudo apt-get install -y python",
            "sudo mkdir /scripts",
            "sudo chmod o+w /scripts",
        ]
    }
    provisioner "file" {
        source = "/etc/fstab"
        destination = "/tmp/fstab"
    }
    provisioner "file" {
        source = "/data/documentos/config/scripts/company/unix/pivot/"
        destination = "/scripts"
    }
    provisioner "remote-exec" {
        inline = [
            "sudo chmod o-w /scripts",
            "sudo chmod 755 /scripts/*",
            "sudo chown -R root:root /scripts",
        ]
    }
    provisioner "local-exec" {
        command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ${aws_instance.vm-wintest01.public_ip}, -u ${var.OS_USER} playbook.yml"
    }
}

# Mostrar en pantalla la IP publica de la instancia EC2 creada
output "ip" {
        value = "${aws_instance.vm-wintest01.public_ip}"
        description = "IP publica dinamica de la instancia"
}
