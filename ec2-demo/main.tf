# Busqueda y eleccion de la AMI deseada
data "aws_ami" "selected" {
  dynamic "filter" {
    for_each = var.amis[var.desired_os].name_pattern == null ? [] : [1]
    content {
      name   = "name"
      values = [var.amis[var.desired_os].name_pattern]
    }
  }

  dynamic "filter" {
    for_each = var.amis[var.desired_os].product_code == null ? [] : [1]
    content {
      name   = "product-code"
      values = [var.amis[var.desired_os].product_code]
    }
  }

  filter {
    name   = "root-device-type"
    values = [var.amis[var.desired_os].disk_type]
  }

  most_recent = true
  owners      = [var.amis[var.desired_os].owners]
}

# Seleccion de VPC por su nombre (Tag:Name)
data "aws_vpc" "selected" {
  tags = {
    Name = var.vpc_name
  }
}

# Seleccion de Subnet por su nombre (Tag:Name)
data "aws_subnet" "selected" {
  tags = {
    Name = var.subnet_name
  }
  vpc_id = data.aws_vpc.selected.id
}

# Seleccion de Security Group por su nombre (Tag:Name)
data "aws_security_group" "selected" {
  count  = length(var.security_group_names)
  vpc_id = data.aws_vpc.selected.id
  tags = {
    Name = var.security_group_names[count.index]
  }
}

# Security Group
resource "aws_security_group" "sg" {
  name        = "SG_${var.tag_name}"
  description = "Permite trafico entrante a las aplicaciones de la instancia"
  vpc_id      = data.aws_vpc.selected.id
  # Tags comunes
  tags = {
    Name      = "SG_${var.tag_name}"
    Owner     = var.tag_owner
    Group     = var.tag_group
    Project   = var.tag_project
    TFProject = var.tag_tf_project

  }
}

# resource "aws_security_group_rule" "sg_rule_http" {
#   type              = "ingress"
#   from_port         = 80
#   to_port           = 80
#   protocol          = "tcp"
#   cidr_blocks       = ["0.0.0.0/0"]
#   security_group_id = aws_security_group.sg.id
# }

# resource "aws_security_group_rule" "sg_rule_https" {
#   type              = "ingress"
#   from_port         = 443
#   to_port           = 443
#   protocol          = "tcp"
#   cidr_blocks       = ["0.0.0.0/0"]
#   security_group_id = aws_security_group.sg.id
# }

# resource "aws_security_group_rule" "sg_rule_ssh" {
#   type              = "ingress"
#   from_port         = 22
#   to_port           = 22
#   protocol          = "tcp"
#   cidr_blocks       = ["0.0.0.0/0"]
#   security_group_id = aws_security_group.sg.id
# }

# resource "aws_security_group_rule" "sg_rule_out" {
#   type              = "egress"
#   from_port         = 0
#   to_port           = 0
#   protocol          = "-1"
#   cidr_blocks       = ["0.0.0.0/0"]
#   security_group_id = aws_security_group.sg.id
# }

# Template de configuracion de la instancia EC2
# data "template_file" "instance_setup" {
#   template = file("${path.module}/templates/owncloud-deployment.tpl")

#   vars = {
#     tpl_app_domain = var.APP_DOMAIN
#     tpl_ssl_cert   = var.SSL_CERT
#     tpl_ssl_key    = var.SSL_KEY
#   }
# }

# Instancia EC2
resource "aws_instance" "ec2instance" {
  subnet_id                   = data.aws_subnet.selected.id # Subnet elegida del filtro
  ami                         = data.aws_ami.selected.id    # AMI elegido del filtro
  vpc_security_group_ids      = [aws_security_group.sg.id]  # Security Group creado
  associate_public_ip_address = var.use_public_ip           # Asignar IP publica a instancia
  count                       = var.instance_count          # Cantidad de instancias a crear
  instance_type               = var.instance_type           # Tipo de instancia a crear
  key_name                    = var.key_name                # Keypair asociado a la instancia
  iam_instance_profile        = var.iam_instance_profile    # Instance Profile IAM asociado a la instancia
  # user_data                   = data.template_file.instance_setup.rendered # User Data que invoca a template de script de configuracion

  root_block_device {
    delete_on_termination = true
  }

  # Common tags
  tags = {
    Name      = var.tag_name
    Owner     = var.tag_owner
    Group     = var.tag_group
    Project   = var.tag_project
    TFProject = var.tag_tf_project
  }
}

