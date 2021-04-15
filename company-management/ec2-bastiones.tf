# Creacion de una instancia bastion Linux en red privada
resource "aws_instance" "vm-linux-pri-bastion" {
        # CentOS 7 (x86_64) - with Updates HVM
        ami = "ami-9887c6e7"
        instance_type = "t2.nano"
        subnet_id = "${aws_subnet.pri-subnet-1.id}"
        vpc_security_group_ids = ["${aws_security_group.SG_SSH.id}"]
        key_name = "${aws_key_pair.KP-arengifo.id}"
        tags {  
                Name = "vm-linux-pri-bastion"
        }
}

# Creacion de una instancia bastion Windows en red privada
resource "aws_instance" "vm-windows-pri-bastion" {
        # Microsoft Windows Server 2012 R2 Base
        ami = "ami-085ea1972627f58fd"
        instance_type = "t2.medium"
        subnet_id = "${aws_subnet.pri-subnet-1.id}"
        vpc_security_group_ids = ["${aws_security_group.SG_RDP.id}"]
        key_name = "${aws_key_pair.KP-arengifo.id}"
        tags {  
                Name = "vm-windows-pri-bastion"
        }
}

# Creacion de una instancia bastion Linux en red publica
resource "aws_instance" "vm-linux-pub-bastion" {
        # CentOS 7 (x86_64) - with Updates HVM
        ami = "ami-9887c6e7"
        instance_type = "t2.nano"
        subnet_id = "${aws_subnet.pub-subnet-1.id}"
        vpc_security_group_ids = ["${aws_security_group.SG_SSH.id}","${aws_security_group.SG_Proxy.id}",]
        key_name = "${aws_key_pair.KP-arengifo.id}"
        tags {  
                Name = "vm-linux-pub-bastion"
        }
}
