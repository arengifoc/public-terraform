# Creacion de una instancia Linux con CentOS 7 para Nagios
resource "aws_instance" "vm-company-lnxmonnag01" {
	# CentOS 7 (x86_64) - with Updates HVM from AWS marketplace
	ami = "ami-9887c6e7"
	instance_type = "t3.xlarge"
	# VPC-Testing-pri-subnet1
	subnet_id = "subnet-xxxxxx"
	# sg_SSHLinux
	vpc_security_group_ids = ["sg-0cb91b8fffe441ffd"]
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
	key_name = "KP-arengifo"
	tags {
		Name = "vm-company-lnxmonnag01"
	}
	provisioner "remote-exec" {
		inline = [
			"sudo yum update -y",
			"sudo sed -i -e '/^SELINUX=/s/^.*$/SELINUX=disabled/g' /etc/selinux/config",
		]
		connection {
			type        = "ssh"
			user        = "centos"
			private_key = "${file("${var.PRIVATE_KEY}")}"
		}
	}
}

# Creacion de una instancia Linux con CentOS 7 para Nagios
resource "aws_instance" "vm-company-lnxmonnag02" {
	# CentOS 7 (x86_64) - with Updates HVM from AWS marketplace
	ami = "ami-9887c6e7"
	instance_type = "t3.xlarge"
	# VPC-Testing-pri-subnet1
	subnet_id = "subnet-xxxxxx"
	# sg_SSHLinux
	vpc_security_group_ids = ["sg-0cb91b8fffe441ffd"]
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
	key_name = "KP-arengifo"
	tags {
		Name = "vm-company-lnxmonnag02"
	}
	provisioner "remote-exec" {
		inline = [
			"sudo yum update -y",
			"sudo sed -i -e '/^SELINUX=/s/^.*$/SELINUX=disabled/g' /etc/selinux/config",
		]
		connection {
			type        = "ssh"
			user        = "centos"
			private_key = "${file("${var.PRIVATE_KEY}")}"
		}
	}
}

# Creacion de una instancia Linux con RHEL 7 para Nagios
resource "aws_instance" "vm-company-lnxmonnag03" {
	# Red Hat Enterprise Linux 7.6 (HVM), SSD Volume Type
	ami = "ami-011b3ccf1bd6db744"
	instance_type = "t3.xlarge"
	# VPC-Testing-pri-subnet1
	subnet_id = "subnet-xxxxxx"
	# sg_SSHLinux
	vpc_security_group_ids = ["sg-0cb91b8fffe441ffd"]
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
	key_name = "KP-arengifo"
	tags {
		Name = "vm-company-lnxmonnag03"
	}
	provisioner "remote-exec" {
		inline = [
			"sudo yum update -y",
			"sudo sed -i -e '/^SELINUX=/s/^.*$/SELINUX=disabled/g' /etc/selinux/config",
		]
		connection {
			type        = "ssh"
			user        = "ec2-user"
			private_key = "${file("${var.PRIVATE_KEY}")}"
		}
	}
}

# Creacion de una instancia Linux con RHEL 7 para Nagios
resource "aws_instance" "vm-company-lnxmonnag04" {
	# Red Hat Enterprise Linux 7.6 (HVM), SSD Volume Type
	ami = "ami-011b3ccf1bd6db744"
	instance_type = "t3.xlarge"
	# VPC-Testing-pri-subnet1
	subnet_id = "subnet-xxxxxx"
	# sg_SSHLinux
	vpc_security_group_ids = ["sg-0cb91b8fffe441ffd"]
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
	key_name = "KP-arengifo"
	tags {
		Name = "vm-company-lnxmonnag04"
	}
	provisioner "remote-exec" {
		inline = [
			"sudo yum update -y",
			"sudo sed -i -e '/^SELINUX=/s/^.*$/SELINUX=disabled/g' /etc/selinux/config",
		]
		connection {
			type        = "ssh"
			user        = "ec2-user"
			private_key = "${file("${var.PRIVATE_KEY}")}"
		}
	}
}

# Mostrar en pantalla la IP privada de la instancia EC2 creada
output "lnxmonnag01-ip" {
	value = "${aws_instance.vm-company-lnxmonnag01.private_ip}"
}

output "lnxmonnag02-ip" {
	value = "${aws_instance.vm-company-lnxmonnag02.private_ip}"
}
