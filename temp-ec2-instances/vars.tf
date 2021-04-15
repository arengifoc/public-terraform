variable "AWS_PROFILE" {
  type        = string
  description = "Nombre del perfil AWS CLI elegido"
}

variable "REGION" {
  type        = string
  description = "Nombre de la region AWS elegida"
  default     = "us-east-1"
}

variable "INSTANCE_COUNT" {
  type        = number
  description = "Cantidad de instancias a crear"
  default     = 1
}

variable "TAG_NAME" {
  type        = string
  description = "Nombre de la(s) instancia(s)"
  default     = "vm-test"
}

variable "TAG_OWNER" {
  type        = string
  description = "Usuario al que pertenece del recurso (parte de usuario del e-mail de trabajo)"
}

variable "TAG_GROUP" {
  type        = string
  description = "Nombre del team al que pertenece el recurso"
}

variable "TAG_PROJECT" {
  type        = string
  description = "Nombre del proyecto al que pertenece el recurso"
}

variable "TAG_DESCRIPTION" {
  type        = string
  description = "Descripcion del recurso"
  default     = null
}

variable "TAG_COMMENT" {
  type    = string
  default = "Creado usando IaC con Terraform"
}

variable "TAG_TERRAFORM_PROJECT" {
  type        = string
  description = "Nombre del proyecto Terraform"
  default     = "temp-ec2-instances"
}

variable "INSTANCE_TYPE" {
  type        = string
  default     = "t3a.micro"
  description = "Nombre valido de tipo de instancia EC2"
}

variable "DESIRED_OS" {
  type        = string
  description = "Nombre amigable de la AMI deseada. Ver valores en variable AMIS. Ejm Amazon Linux 2"
  default     = null
}

variable "AMIS" {
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

variable "VPC_NAME" {
  type        = string
  default     = null
  description = "Nombre de la VPC segun el tag Name"
}

variable "SUBNET_NAME" {
  type        = string
  default     = null
  description = "Nombre de la Subnet segun el tag Name"
}

variable "SUBNET_ID" {
  type        = string
  description = "ID de subnet deseada"
  default     = null
}

variable "SECURITY_GROUP_NAMES" {
  type        = list(string)
  description = "Nombres de los security groups deseados segun el tag Name"
}

variable "KEY_NAME" {
  type        = string
  description = "Nombre del Keypair SSH a asociar a la instancia"
}

variable "SECURITY_GROUP_IDS" {
  type        = list
  description = "Lista de IDs de security groups a asociar a la instancia"
  default     = []
}

variable "IAM_INSTANCE_PROFILE" {
  type        = string
  description = "Nombre del ool IAM a aplicar a la instancia"
  default     = null
}
