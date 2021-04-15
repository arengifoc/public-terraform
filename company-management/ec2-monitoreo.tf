# Creacion de dos instancias RHEL 8 para Spectrum en red privada
resource "aws_instance" "vm-linux-spectrum1" {
        # Red Hat Enterprise Linux 7.6 (HVM), SSD Volume Type
        ami = "ami-011b3ccf1bd6db744"
        instance_type = "t3.xlarge"
        subnet_id = "${aws_subnet.pri-subnet-1.id}"
        vpc_security_group_ids = ["${aws_security_group.SG_SSH.id}"]
        key_name = "${aws_key_pair.KP-arengifo.id}"

        root_block_device {
                volume_size = "100"
                volume_type = "standard"
                delete_on_termination = true
        }

        ebs_block_device {
                device_name = "/dev/sdb"
                volume_size = "8"
                volume_type = "gp2"
                delete_on_termination = true
                encrypted = false
        }

        tags {  
                Name = "vm-linux-spectrum1"
        }
}

# Creacion de dos instancias RHEL 8 para Spectrum en red privada
resource "aws_instance" "vm-linux-spectrum2" {
        # Red Hat Enterprise Linux 7.6 (HVM), SSD Volume Type
        ami = "ami-011b3ccf1bd6db744"
        instance_type = "t3.xlarge"
        subnet_id = "${aws_subnet.pri-subnet-1.id}"
        vpc_security_group_ids = ["${aws_security_group.SG_SSH.id}"]
        key_name = "${aws_key_pair.KP-arengifo.id}"

        root_block_device {
                volume_size = "100"
                volume_type = "standard"
                delete_on_termination = true
        }

        ebs_block_device {
                device_name = "/dev/sdb"
                volume_size = "8"
                volume_type = "gp2"
                delete_on_termination = true
                encrypted = false
        }

        tags {  
                Name = "vm-linux-spectrum2"
        }
}
