# Creacion de la VPC
resource "aws_vpc" "VPC-Testing" {
	cidr_block = "10.201.0.0/23"
	tags {
		Name = "VPC-Testing"
	}
}

# Creacion de subred privada 1
resource "aws_subnet" "pri-subnet-1" {
	vpc_id = "${aws_vpc.VPC-Testing.id}"
	cidr_block = "10.201.0.0/27"
	availability_zone = "us-east-1a"
	tags {
		Name = "VPC-Testing-pri-subnet1"
	}
}

# Creacion de subred privada 2
resource "aws_subnet" "pri-subnet-2" {
	vpc_id = "${aws_vpc.VPC-Testing.id}"
	cidr_block = "10.201.0.32/27"
	availability_zone = "us-east-1b"
	tags {
		Name = "VPC-Testing-pri-subnet2"
	}
}

# Creacion de subred publica 1
resource "aws_subnet" "pub-subnet-1" {
	vpc_id = "${aws_vpc.VPC-Testing.id}"
	cidr_block = "10.201.0.64/27"
	availability_zone = "us-east-1a"
	tags {
		Name = "VPC-Testing-pub-subnet-1"
	}
}

# Creacion de subred publica 2
resource "aws_subnet" "pub-subnet-2" {
	vpc_id = "${aws_vpc.VPC-Testing.id}"
	cidr_block = "10.201.0.96/27"
	availability_zone = "us-east-1b"
	tags {
		Name = "VPC-Testing-pub-subnet-2"
	}
}

# Creacion del Internet Gateway
resource "aws_internet_gateway" "IGW2" {
	vpc_id = "${aws_vpc.VPC-Testing.id}"
	tags {
		Name = "IGW2"
	}
}

# Creacion de una IP elastica para el NAT Gateway
resource "aws_eip" "EIP-NGW-pub-subnet-1" {
	vpc = true	
	depends_on = ["aws_internet_gateway.IGW2"]
}

# Creacion de NAT Gateway en la subred publica 1
resource "aws_nat_gateway" "NGW-pub-subnet-1" {
	allocation_id = "${aws_eip.EIP-NGW-pub-subnet-1.id}"
	subnet_id = "${aws_subnet.pub-subnet-1.id}"
	tags {
		Name = "NGW-VPC-Testing-pub-subnet-1"
	}
	depends_on = ["aws_internet_gateway.IGW2"]
}

# Creacion de una tabla de rutas para subredes publicas
resource "aws_route_table" "RT-VPC-Testing-pub-subnets" {
	vpc_id = "${aws_vpc.VPC-Testing.id}"
	tags {
		Name = "RT-VPC-Testing-pub-subnets"
	}
	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = "${aws_internet_gateway.IGW2.id}"
	}
	route {
		ipv6_cidr_block = "::/0"
		gateway_id = "${aws_internet_gateway.IGW2.id}"
	}
	route {
		cidr_block = "172.24.1.220/32"
		gateway_id = "${aws_vpn_gateway.VGW2.id}"
	}
	route {
		cidr_block = "10.0.13.10/32"
		gateway_id = "${aws_vpn_gateway.VGW2.id}"
	}
	route {
		cidr_block = "10.240.0.0/24"
		gateway_id = "${aws_vpn_gateway.VGW2.id}"
	}
	route {
		cidr_block = "10.240.5.0/24"
		gateway_id = "${aws_vpn_gateway.VGW2.id}"
	}
}

# Creacion de una tabla de rutas para subredes privadas
resource "aws_route_table" "RT-VPC-Testing-pri-subnets" {
	vpc_id = "${aws_vpc.VPC-Testing.id}"
	tags {
		Name = "RT-VPC-Testing-pri-subnets"
	}
	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = "${aws_nat_gateway.NGW-pub-subnet-1.id}"
	}
	route {
		cidr_block = "172.24.1.220/32"
		gateway_id = "${aws_vpn_gateway.VGW2.id}"
	}
	route {
		cidr_block = "10.0.13.10/32"
		gateway_id = "${aws_vpn_gateway.VGW2.id}"
	}
	route {
		cidr_block = "10.240.0.0/24"
		gateway_id = "${aws_vpn_gateway.VGW2.id}"
	}
	route {
		cidr_block = "10.240.5.0/24"
		gateway_id = "${aws_vpn_gateway.VGW2.id}"
	}
}

# Asociar las subredes publicas con la tabla de enrutamiento publica
resource "aws_route_table_association" "association-pub-subnet-1" {
	subnet_id = "${aws_subnet.pub-subnet-1.id}"
	route_table_id = "${aws_route_table.RT-VPC-Testing-pub-subnets.id}"
}

resource "aws_route_table_association" "association-pub-subnet-2" {
	subnet_id = "${aws_subnet.pub-subnet-2.id}"
	route_table_id = "${aws_route_table.RT-VPC-Testing-pub-subnets.id}"
}

# Asociar las subredes privadas con la tabla de enrutamiento privada
resource "aws_route_table_association" "association-pri-subnet-1" {
	subnet_id = "${aws_subnet.pri-subnet-1.id}"
	route_table_id = "${aws_route_table.RT-VPC-Testing-pri-subnets.id}"
}

resource "aws_route_table_association" "association-pri-subnet-2" {
	subnet_id = "${aws_subnet.pri-subnet-2.id}"
	route_table_id = "${aws_route_table.RT-VPC-Testing-pri-subnets.id}"
}

# Creacion del VPN Gateway
resource "aws_vpn_gateway" "VGW2" {
	vpc_id = "${aws_vpc.VPC-Testing.id}"
	tags {
		Name = "VGW2"
	}
}

# Definicion del Customer Gateway a importar
resource "aws_customer_gateway" "CGW" {
	bgp_asn    = 65000
	ip_address = "200.41.98.3"
	type       = "ipsec.1"
}

# Importar el Customer Gateway desde CLI
#
# terraform import aws_customer_gateway.CGW cgw-09669c29c9cf35d4a

# Creacion de una conexion VPN
resource "aws_vpn_connection" "VPN-COMPANY-COT4-Testing" {
	vpn_gateway_id = "${aws_vpn_gateway.VGW2.id}"
	customer_gateway_id = "${aws_customer_gateway.CGW.id}"
	type = "ipsec.1"
	static_routes_only = true
	tags {
		Name = "VPN-COMPANY-COT4-Testing"
	}
}

# Creacion de rutas a traves de la VPN
resource "aws_vpn_connection_route" "COMPANY-red-company-1" {
	destination_cidr_block = "10.0.13.10/32"
	vpn_connection_id = "${aws_vpn_connection.VPN-COMPANY-COT4-Testing.id}"
}

resource "aws_vpn_connection_route" "COMPANY-red-company-2" {
	destination_cidr_block = "172.24.1.220/32"
	vpn_connection_id = "${aws_vpn_connection.VPN-COMPANY-COT4-Testing.id}"
}

resource "aws_vpn_connection_route" "COMPANY-red-company-3" {
	destination_cidr_block = "10.240.0.0/24"
	vpn_connection_id = "${aws_vpn_connection.VPN-COMPANY-COT4-Testing.id}"
}

resource "aws_vpn_connection_route" "COMPANY-red-company-4" {
	destination_cidr_block = "10.240.5.0/24"
	vpn_connection_id = "${aws_vpn_connection.VPN-COMPANY-COT4-Testing.id}"
}

# Crear un keypair
resource "aws_key_pair" "KP-linux-test" {
	key_name = "KP-linux-test"
	public_key = "${file("${var.PUBLIC_KEY}")}"
}

# Creacion de una instancia de pruebas en una subred privada
resource "aws_instance" "linux-test" {
	ami = "ami-0922553b7b0369273"
	instance_type = "t2.nano"
	subnet_id = "${aws_subnet.pri-subnet-1.id}"
	vpc_security_group_ids = ["sg-0cb91b8fffe441ffd"]
	key_name = "${aws_key_pair.KP-linux-test.id}"
	tags {
		Name = "linux-test"
	}
}
