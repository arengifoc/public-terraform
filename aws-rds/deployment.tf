resource "aws_db_subnet_group" "db_subnet_demo" {
	name = "db_subnet_demo"
	subnet_ids = ["subnet-xxxxxx","subnet-xxxxxx"]
	tags {
		Name = "db_subnet_demo"
	}
}

resource "aws_security_group" "SG_MariaDB" {
        name        = "SG_MariaDB"
        description = "Permitir trafico MariaDB entrante"
        vpc_id      = "vpc-xxxxxx"
        ingress {
                from_port   = 3306
                to_port     = 3306
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
	password             = "P4k42018.."
	skip_final_snapshot  = true
	db_subnet_group_name = "${aws_db_subnet_group.db_subnet_demo.id}"
	vpc_security_group_ids = ["${aws_security_group.SG_MariaDB.id}"]
}

resource "local_file" "mysql_db" {
	content  = "mysql_host: ${aws_db_instance.wordpress.name}\n"
	filename = "vars/mysql_db.yml"
}

resource "local_file" "mysql_host" {
	content  = "mysql_host: ${aws_db_instance.wordpress.endpoint}\n"
	filename = "vars/mysql_host.yml"
}

resource "local_file" "mysql_user" {
	content  = "mysql_host: ${aws_db_instance.wordpress.username}\n"
	filename = "vars/mysql_user.yml"
}

resource "local_file" "mysql_password" {
	content  = "mysql_root_password: ${aws_db_instance.wordpress.password}\n"
	filename = "vars/mysql_password.yml"
}
