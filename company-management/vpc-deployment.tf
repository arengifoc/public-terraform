# Creacion de la VPC
resource "aws_vpc" "VPC-Management" {
	cidr_block = "10.150.0.0/24"
	tags {
		Name = "VPC-Management"
	}
}

# Creacion de subred privada 1
resource "aws_subnet" "pri-subnet-1" {
	vpc_id = "${aws_vpc.VPC-Management.id}"
	cidr_block = "10.150.0.0/27"
	availability_zone = "us-east-1a"
        map_public_ip_on_launch = false
	tags {
		Name = "VPC-Management-pri-subnet1"
	}
}

# Creacion de subred publica 1
resource "aws_subnet" "pub-subnet-1" {
	vpc_id = "${aws_vpc.VPC-Management.id}"
	cidr_block = "10.150.0.32/27"
	availability_zone = "us-east-1a"
        map_public_ip_on_launch = true
	tags {
		Name = "VPC-Management-pub-subnet1"
	}
}

# Creacion de subred privada 2
resource "aws_subnet" "pri-subnet-2" {
	vpc_id = "${aws_vpc.VPC-Management.id}"
	cidr_block = "10.150.0.64/27"
	availability_zone = "us-east-1b"
        map_public_ip_on_launch = false
	tags {
		Name = "VPC-Management-pri-subnet2"
	}
}

# Creacion de subred publica 2
resource "aws_subnet" "pub-subnet-2" {
	vpc_id = "${aws_vpc.VPC-Management.id}"
	cidr_block = "10.150.0.96/27"
	availability_zone = "us-east-1b"
        map_public_ip_on_launch = true
	tags {
		Name = "VPC-Management-pub-subnet2"
	}
}

# Creacion del Internet Gateway
resource "aws_internet_gateway" "IGW-Management" {
	vpc_id = "${aws_vpc.VPC-Management.id}"
	tags {
		Name = "IGW-Management"
	}
}

# Creacion de una tabla de rutas para salida a Internet a traves del
# Internet Gateway
resource "aws_route_table" "RT-Management-pub-subnets" {
	vpc_id = "${aws_vpc.VPC-Management.id}"
	tags {
		Name = "RT-Management-pub-subnets"
	}
	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = "${aws_internet_gateway.IGW-Management.id}"
	}
}

# Asociar la subred publica 1 con la primera tabla de enrutamiento
resource "aws_route_table_association" "association-pub-subnet-1" {
	subnet_id = "${aws_subnet.pub-subnet-1.id}"
	route_table_id = "${aws_route_table.RT-Management-pub-subnets.id}"
}

# Asociar la subred publica 2 con la primera tabla de enrutamiento
resource "aws_route_table_association" "association-pub-subnet-2" {
	subnet_id = "${aws_subnet.pub-subnet-2.id}"
	route_table_id = "${aws_route_table.RT-Management-pub-subnets.id}"
}
