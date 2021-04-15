# Creacion de un VPC
resource "aws_vpc" "VPC_1" {
  cidr_block = "10.142.0.0/16"
  tags {
    Name = "VPC_test"
  }
}

# Creacion de subred privada
resource "aws_subnet" "SN_pri" {
  vpc_id = "${aws_vpc.VPC_1.id}"
  cidr_block = "10.142.3.0/24"
  availability_zone = "us-east-1a"
  tags {
    Name = "SN_pri-10_142_3_0"
  }
}

# Creacion de subred publica
  resource "aws_subnet" "SN_pub" {
  vpc_id = "${aws_vpc.VPC_1.id}"
  cidr_block = "10.142.6.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
  tags {
    Name = "SN_pub-10_142_6_0"
  }
}

# Creacion de un Internet Gateway para la subred publica
resource "aws_internet_gateway" "IGW_1" {
  vpc_id = "${aws_vpc.VPC_1.id}"
  tags {
    Name = "IGW-test"
  }
}

# Creacion de una tabla de rutas para salida a Internet a traves del
# Internet Gateway
resource "aws_route_table" "RT_1" {
  vpc_id = "${aws_vpc.VPC_1.id}"
  tags {
    Name = "RT_SN_pub"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.IGW_1.id}"
  }
}

# Asociar la subred publica con la tabla de enrutamiento creada
resource "aws_route_table_association" "RTASOC_1" {
  subnet_id = "${aws_subnet.SN_pub.id}"
  route_table_id = "${aws_route_table.RT_1.id}"
}

# Creacion de un Keypair SSH "KP_default"
resource "aws_key_pair" "KP_default" {
  key_name = "KP_default"
  public_key = "${file("${var.PUBLIC_KEY}")}"
}

# Creacion de un Security Group "KP_default". Permite el acceso SSH y RDP desde el
# exterior y brinda salida libre a Internet
resource "aws_security_group" "SG_default" {
  # Nombre del Security Group
  name        = "SG_default"

  # Asociarlo con el VPC creado
  vpc_id      = "${aws_vpc.VPC_1.id}"

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
  ingress {
    from_port = 8
    to_port = 0
    protocol = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  # Reglas de salida al exterior
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  
  # Nombre del Security Group con tags
  tags {
    Name = "SG_default"
  }
}

# Creacion de una instancia Linux, con nombre interno “vm-lnx01” y nombre
# en EC2 "vm-lnxprueba01"
resource "aws_instance" "vm-lnx01" {
  # AMI de Amazon Linux 2 AMI (HVM), SSD Volume Type en N. Virginia
  ami = "ami-035be7bafff33b6b6"

  # Tamanio de instancia
  instance_type = "t3.nano"

  # Keypair SSH a usar
  key_name = "${aws_key_pair.KP_default.id}"

  # Asociacion con la subred publica
  subnet_id = "${aws_subnet.SN_pub.id}"

  # Asociar el Security Group "SG_default" creado anteriormente
  vpc_security_group_ids = ["${aws_security_group.SG_default.id}"]

  # Asignar el nombre a la VM usando tags
  tags {
    Name = "vm-lnxprueba01"
  }
}

# Creacion de una instancia Windows, con nombre interno “vm-win01” y nombre
# en EC2 "vm-winprueba01"
resource "aws_instance" "vm-win01" {
  # AMI de Microsoft Windows Server 2008 R2 Base
  ami = "ami-04a6682fa43c74174"

  # Tamanio de instancia
  instance_type = "t3.micro"

  # Keypair SSH a usar
  key_name = "${aws_key_pair.KP_default.id}"

  # Asociacion con la subred privada
  subnet_id = "${aws_subnet.SN_pri.id}"

  # Asociar el Security Group "SG_default" creado anteriormente
  vpc_security_group_ids = ["${aws_security_group.SG_default.id}"]

  # Asignar el nombre a la VM usando tags
  tags {
    Name = "vm-winprueba01"
  }
}
