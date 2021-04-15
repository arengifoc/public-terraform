# Crear un keypair
resource "aws_key_pair" "KP-arengifo" {
        key_name = "KP-arengifo"
        public_key = "${file("${var.PUBLIC_KEY}")}"
}

# Creacion de Security Group para acceso SSH
resource "aws_security_group" "SG_SSH" {
        name        = "SG_SSH"
        description = "Permitir trafico SSH"
        vpc_id      = "${aws_vpc.VPC-Management.id}"
        ingress {
                from_port   = 22
                to_port     = 22
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
            Name = "SG_SSH"
        }
}

# Creacion de Security Group para acceso Proxy Squid
resource "aws_security_group" "SG_Proxy" {
        name        = "SG_Proxy"
        description = "Permitir trafico Proxy"
        vpc_id      = "${aws_vpc.VPC-Management.id}"
        ingress {
                from_port   = 3128
                to_port     = 3128
                protocol    = "tcp"
                cidr_blocks = ["10.150.0.0/24"]
        }
        tags {
            Name = "SG_Proxy"
        }
}

# Creacion de Security Group para acceso RDP
resource "aws_security_group" "SG_RDP" {
        name        = "SG_RDP"
        description = "Permitir trafico RDP"
        vpc_id      = "${aws_vpc.VPC-Management.id}"
        ingress {
                from_port   = 3389
                to_port     = 3389
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
            Name = "SG_RDP"
        }
}

# Creacion de Security Group para acceso SMTP
resource "aws_security_group" "SG_SMTP" {
        name        = "SG_SMTP"
        description = "Permitir trafico SMTP"
        vpc_id      = "${aws_vpc.VPC-Management.id}"
        ingress {
                from_port   = 25
                to_port     = 25
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
            Name = "SG_SMTP"
        }
}
