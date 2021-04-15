#####################################################################
# Transito multicliente - VPC
resource "aws_vpc" "vpc-Transito" {
  cidr_block = "10.150.0.0/24"

  tags {
    Name = "VPC-Transito"
  }
}

# Transito Multicliente - Subnet publica 1 (us-east-1a)
resource "aws_subnet" "subnet-Transito-pub1" {
  vpc_id                  = "${aws_vpc.vpc-Transito.id}"
  cidr_block              = "10.150.0.0/28"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags {
    Name = "subnet-Transito-pub1"
  }
}

# Transito Multicliente - Subnet publica 2 (us-east-1b)
resource "aws_subnet" "subnet-Transito-pub2" {
  vpc_id                  = "${aws_vpc.vpc-Transito.id}"
  cidr_block              = "10.150.0.16/28"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags {
    Name = "subnet-Transito-pub2"
  }
}

# Transito Multicliente - Internet Gateway
resource "aws_internet_gateway" "igw-Transito" {
  vpc_id = "${aws_vpc.vpc-Transito.id}"

  tags {
    Name = "igw-Transito"
  }
}

# Transito Multicliente - Route table publico
resource "aws_route_table" "routetable-Transito-pub" {
  vpc_id = "${aws_vpc.vpc-Transito.id}"

  tags {
    Name = "routetable-Transito-pub"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw-Transito.id}"
  }
}

# Transito Multicliente - Asociacion de subredes con Route table publico
resource "aws_route_table_association" "subnetassociation-subnet-Transito-pub1" {
  subnet_id      = "${aws_subnet.subnet-Transito-pub1.id}"
  route_table_id = "${aws_route_table.routetable-Transito-pub.id}"
}

resource "aws_route_table_association" "subnetassociation-subnet-Transito-pub2" {
  subnet_id      = "${aws_subnet.subnet-Transito-pub2.id}"
  route_table_id = "${aws_route_table.routetable-Transito-pub.id}"
}

#####################################################################
# Cloud hibrido - VPC
resource "aws_vpc" "vpc-CloudHibrido" {
  cidr_block = "10.150.1.0/24"

  tags {
    Name = "VPC-CloudHibrido"
  }
}

# Cloud Hibrido - Subnet privada 1 (us-east-1a)
resource "aws_subnet" "subnet-CloudHibrido-pri1" {
  vpc_id                  = "${aws_vpc.vpc-CloudHibrido.id}"
  cidr_block              = "10.150.1.0/28"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = false

  tags {
    Name = "subnet-CloudHibrido-pri1"
  }
}

# Cloud Hibrido - Subnet privada 2 (us-east-1b)
resource "aws_subnet" "subnet-CloudHibrido-pri2" {
  vpc_id                  = "${aws_vpc.vpc-CloudHibrido.id}"
  cidr_block              = "10.150.1.16/28"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = false

  tags {
    Name = "subnet-CloudHibrido-pri2"
  }
}

# Cloud Hibrido - Internet Gateway
resource "aws_internet_gateway" "igw-CloudHibrido" {
  vpc_id = "${aws_vpc.vpc-CloudHibrido.id}"

  tags {
    Name = "igw-CloudHibrido"
  }
}

#####################################################################

