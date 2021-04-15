#############################
# Variables de imagen de SO #
#############################

variable "desired_os" {
  type        = string
  description = "Nombre amigable de la AMI deseada. Ver valores en variable AMIS. Ejm Amazon Linux 2"
}

variable "amis" {
  type = map(object({
    short_name   = string
    owners       = string
    name_pattern = string
    default_user = string
    product_code = string
    disk_type    = string
  }))
  default = {
    "Amazon Linux" = {
      short_name   = "amzn"
      owners       = "137112412989"
      name_pattern = "amzn-ami-hvm-????.??.*.????????-x86_64-gp2"
      default_user = "ec2-user"
      disk_type    = "ebs"
      product_code = null
    }
    "Amazon Linux 2" = {
      short_name   = "amzn2"
      owners       = "137112412989"
      name_pattern = "amzn2-ami-hvm-2.0.????????-x86_64-gp2"
      default_user = "ec2-user"
      disk_type    = "ebs"
      product_code = null
    }
    "Ubuntu Server 18.04" = {
      short_name   = "ubuntu18.04"
      owners       = "099720109477"
      name_pattern = "ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"
      default_user = "ubuntu"
      disk_type    = "ebs"
      product_code = null
    }
    "CentOS 7" = {
      short_name   = "centos7"
      owners       = "aws-marketplace"
      name_pattern = null
      default_user = "centos"
      disk_type    = "ebs"
      product_code = "aw0evgkw8e5c1q413zgy5pjce"
    }
    "Windows 2016" = {
      short_name   = "windows2016"
      owners       = "801119661308"
      name_pattern = "Windows_Server-2016-English-Full-Base-*"
      default_user = "administrator"
      disk_type    = "ebs"
      product_code = null
    }
  }
}

###############################
# Variables de entorno de red #
###############################

variable "vpc_name" {
  type        = string
  description = "Nombre de la VPC segun el tag Name"
}

variable "subnet_name" {
  type        = string
  description = "Nombre de la Subnet segun el tag Name"
}


variable "security_group_names" {
  type        = list(string)
  description = "Nombres de los security groups deseados segun el tag Name"
}

variable "use_public_ip" {
  type        = bool
  description = "Define si se asigna una IP publica o no a la instancia"
  default     = null
}

# variable "SUBNET_ID" {
#   type        = string
#   description = "ID de subnet deseada"
#   default     = null
# }

# variable "SECURITY_GROUP_IDS" {
#   type        = list
#   description = "Lista de IDs de security groups a asociar a la instancia"
#   default     = []
# }

#####################
# Variables de Tags #
#####################

variable "tag_name" {
  type        = string
  description = "Nombre de la(s) instancia(s)"
  # default     = null
}

variable "tag_owner" {
  type        = string
  description = "Usuario al que pertenece del recurso (parte de usuario del e-mail de trabajo)"
  # default     = null
}

variable "tag_group" {
  type        = string
  description = "Nombre del team al que pertenece el recurso"
  # default     = null
}

variable "tag_project" {
  type        = string
  description = "Nombre del proyecto al que pertenece el recurso"
  # default     = null
}

# variable "tag_description" {
#   type        = string
#   description = "Descripcion del recurso"
#   # default     = null
# }

variable "tag_tf_project" {
  type        = string
  description = "Nombre del proyecto Terraform"
  # default     = null
}

# variable "TAG_COMMENT" {
#   type    = string
#   default = "Creado usando IaC con Terraform"
# }


#######################################
# Variables de atributos de instancia #
#######################################

variable "instance_count" {
  type        = number
  description = "Cantidad de instancias a crear"
  default     = null
}

variable "instance_type" {
  type        = string
  description = "Nombre valido de tipo de instancia EC2"
}

variable "iam_instance_profile" {
  type        = string
  description = "Nombre del rol IAM a aplicar a la instancia"
  default     = null
}

variable "key_name" {
  type        = string
  description = "Nombre del Keypair SSH a asociar a la instancia"
  default     = null
}

variable "delete_rootdisk_on_termination" {
  type        = bool
  description = "Define si eliminar o no el disco de SO al borrar la instancia"
  default     = null
}


###################
# Variables extra #
###################

# variable "BUCKET_NAME" {
#   type        = string
#   description = "Nombre del bucket S3"
# }

# variable "APP_DOMAIN" {
#   type        = string
#   description = "Virtual host de la aplicacion Web a configurar"
# }

# variable "SSL_CERT" {
#   type        = string
#   description = "Certificado digital PEM codificado"
# }

# variable "SSL_KEY" {
#   type        = string
#   description = "Llave privada"
# }

