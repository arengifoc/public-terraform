# Generacion de una cadena aleatoria como clave para la BD
resource "random_string" "mysql_password" {
	length = 16
	special = false
	upper = true
	lower = true
	number = true
}

# Creacion de la VPC
resource "aws_vpc" "VPC-Demo" {
	cidr_block = "10.202.0.0/23"
	tags {
		Name = "VPC-Demo"
	}
}

# Creacion de subred privada 1
resource "aws_subnet" "pri-subnet-1" {
	vpc_id = "${aws_vpc.VPC-Demo.id}"
	cidr_block = "10.202.0.0/27"
	availability_zone = "us-east-1a"
	tags {
		Name = "VPC-Demo-pri-subnet1"
	}
}

# Creacion de subred privada 2
resource "aws_subnet" "pri-subnet-2" {
	vpc_id = "${aws_vpc.VPC-Demo.id}"
	cidr_block = "10.202.0.32/27"
	availability_zone = "us-east-1b"
	tags {
		Name = "VPC-Demo-pri-subnet2"
	}
}

# Creacion de subred publica 1
resource "aws_subnet" "pub-subnet-1" {
	vpc_id = "${aws_vpc.VPC-Demo.id}"
	cidr_block = "10.202.0.64/27"
	availability_zone = "us-east-1a"
	map_public_ip_on_launch = true
	tags {
		Name = "VPC-Demo-pub-subnet-1"
	}
}

# Creacion del Internet Gateway
resource "aws_internet_gateway" "IGW3" {
	vpc_id = "${aws_vpc.VPC-Demo.id}"
	tags {
		Name = "IGW3"
	}
}

# Creacion de una IP elastica para el NAT Gateway
resource "aws_eip" "EIP-NGW-pub-subnet-1" {
	vpc = true	
	depends_on = ["aws_internet_gateway.IGW3"]
}

# Creacion de NAT Gateway en la subred publica 1
resource "aws_nat_gateway" "NGW-pub-subnet-1" {
	allocation_id = "${aws_eip.EIP-NGW-pub-subnet-1.id}"
	subnet_id = "${aws_subnet.pub-subnet-1.id}"
	tags {
		Name = "NGW-VPC-Demo-pub-subnet-1"
	}
	depends_on = ["aws_internet_gateway.IGW3"]
}

# Creacion de una tabla de rutas para salida a Internet a traves del
# Internet Gateway
resource "aws_route_table" "RT-VPC-Demo-pub-subnets" {
	vpc_id = "${aws_vpc.VPC-Demo.id}"
	tags {
		Name = "RT-VPC-Demo-pub-subnets"
	}
	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = "${aws_internet_gateway.IGW3.id}"
	}
}

# Creacion de una tabla de rutas para salida a Internet a traves del NAT
# Gateway y llegada a una red On premise (10.240.5.0/24)
resource "aws_route_table" "RT-VPC-Demo-pri-subnets" {
	vpc_id = "${aws_vpc.VPC-Demo.id}"
	tags {
		Name = "RT-VPC-Demo-pri-subnets"
	}
	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = "${aws_nat_gateway.NGW-pub-subnet-1.id}"
	}
	route {
		cidr_block = "10.240.5.0/24"
		gateway_id = "${aws_vpn_gateway.VGW3.id}"
	}
}

# Asociar las subredes publicas con la primera tabla de enrutamiento
resource "aws_route_table_association" "association-pub-subnet-1" {
	subnet_id = "${aws_subnet.pub-subnet-1.id}"
	route_table_id = "${aws_route_table.RT-VPC-Demo-pub-subnets.id}"
}

# Asociar las subredes publicas con la segunda tabla de enrutamiento
resource "aws_route_table_association" "association-pri-subnet-1" {
	subnet_id = "${aws_subnet.pri-subnet-1.id}"
	route_table_id = "${aws_route_table.RT-VPC-Demo-pri-subnets.id}"
}

# Creacion del VPN Gateway
resource "aws_vpn_gateway" "VGW3" {
	vpc_id = "${aws_vpc.VPC-Demo.id}"
	tags {
		Name = "VGW3"
	}
}

# Definicion del Customer Gateway con su IP publica On premise
resource "aws_customer_gateway" "CGW3" {
	bgp_asn    = 65000
	ip_address = "201.93.127.82"
	type       = "ipsec.1"
}

## Creacion de una conexion VPN
resource "aws_vpn_connection" "VPN-COMPANY-COT4-Demo" {
	vpn_gateway_id = "${aws_vpn_gateway.VGW3.id}"
	customer_gateway_id = "${aws_customer_gateway.CGW3.id}"
	type = "ipsec.1"
	static_routes_only = true
	tags {
		Name = "VPN-COMPANY-COT4-Demo"
	}
}

# Definicion de la red On premise que sera accesible via VPN
resource "aws_vpn_connection_route" "COMPANY-red-company" {
	destination_cidr_block = "10.240.5.0/24"
	vpn_connection_id = "${aws_vpn_connection.VPN-COMPANY-COT4-Demo.id}"
}

# Crear un keypair
resource "aws_key_pair" "KP-ssh-arengifo" {
	key_name = "KP-ssh-arengifo"
	public_key = "${file("${var.PUBLIC_KEY}")}"
}

# Crear un security group para la instancia EC2
resource "aws_security_group" "SG_SSHWeb" {
	name        = "SG_SSHWeb"
	description = "Permitir trafico SSH y Web entrante"
	vpc_id      = "${aws_vpc.VPC-Demo.id}"
	ingress {
		from_port   = 22
		to_port     = 22
		protocol    = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}
	ingress {
		from_port   = 80
		to_port     = 80
		protocol    = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}
	egress {
		from_port       = 0
		to_port         = 0
		protocol        = "-1"
		cidr_blocks     = ["0.0.0.0/0"]
	}
}

# Crear un security group para la instancia RDS
resource "aws_security_group" "SG_MariaDB" {
	name        = "SG_MariaDB"
	description = "Permitir trafico MariaDB entrante"
	vpc_id      = "${aws_vpc.VPC-Demo.id}"
	ingress {
		from_port   = 3306
		to_port     = 3306
		protocol    = "tcp"
		cidr_blocks = ["${aws_subnet.pub-subnet-1.cidr_block}"]
	}
	egress {
		from_port       = 0
		to_port         = 0
		protocol        = "-1"
		cidr_blocks     = ["0.0.0.0/0"]
	}
}

# Recurso subred de BD
resource "aws_db_subnet_group" "db_subnet_demo" {
	name       = "db_subnet_demo"
	subnet_ids = ["${aws_subnet.pri-subnet-1.id}","${aws_subnet.pri-subnet-2.id}"]
	tags {
		Name = "db_subnet_demo"
	}
}


# Instancia de BD MariaDB en RDS
resource "aws_db_instance" "wordpress" {
	allocated_storage    = 20
	storage_type         = "gp2"
	engine               = "mariadb"
	engine_version       = "10.3.8"
	instance_class       = "db.t2.micro"
	identifier           = "wordpress"
	name                 = "wordpress"
	username             = "wordpress_user"
	password             = "${random_string.mysql_password.result}"
	skip_final_snapshot  = true
	db_subnet_group_name = "${aws_db_subnet_group.db_subnet_demo.id}"
	vpc_security_group_ids = ["${aws_security_group.SG_MariaDB.id}"]
	#depends_on = ["random_string.mysql_password"]
}

# Creacion de una instancia de pruebas en una subred privada
resource "aws_instance" "linux-wordpress" {
	# Ubuntu Server 18.04 LTS (HVM), SSD Volume Type
	ami = "ami-0ac019f4fcb7cb7e6"
	instance_type = "t2.nano"
	subnet_id = "${aws_subnet.pub-subnet-1.id}"
	vpc_security_group_ids = ["${aws_security_group.SG_SSHWeb.id}"]
	key_name = "${aws_key_pair.KP-ssh-arengifo.id}"
	tags {
		Name = "linux-wordpress"
	}
	provisioner "remote-exec" {
		inline = [
			"sudo apt-get update",
			"sudo apt-get install -y python",
		]
		connection {
			type        = "ssh"
			user        = "ubuntu"
			private_key = "${file("${var.PRIVATE_KEY}")}"
		}
	}
}

# Escribir en archivos de variables de Ansible los valores de conexion
# a la base de datos
resource "local_file" "eip" {
        content  = "${aws_instance.linux-wordpress.public_ip}\n"
        filename = "inventory.ini"
}

resource "local_file" "mysql_db" {
        content  = "mysql_db: ${aws_db_instance.wordpress.name}\n"
        filename = "vars/mysql_db.yml"
}

resource "local_file" "mysql_host" {
        content  = "mysql_host: ${element(split(":", aws_db_instance.wordpress.endpoint),0)}\n"
        filename = "vars/mysql_host.yml"
}

resource "local_file" "mysql_user" {
        content  = "mysql_user: ${aws_db_instance.wordpress.username}\n"
        filename = "vars/mysql_user.yml"
}

resource "local_file" "mysql_password" {
        content  = "mysql_password: ${aws_db_instance.wordpress.password}\n"
        filename = "vars/mysql_password.yml"
}

# Invocamos a Ansible para que realice el despliegue de configuraciones de Wordpress
# sobre la instancia EC2 creada
resource "null_resource" "instance_execution" {
	triggers {
		 build_number = "${timestamp()}"
	}
	provisioner "local-exec" {
		command = "ansible-playbook -i inventory.ini -u ubuntu wordpress-playbook.yml"
	}
}

# Mostrar en pantalla la IP publica de la instancia EC2 creada
output "ip" {
	value = "${aws_instance.linux-wordpress.public_ip}"
}
