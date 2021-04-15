variable "AWS_PROFILE" {
  type        = string
  description = "Perfil AWS CLI elegido"
}

variable "REGION" {
  type        = string
  description = "Region elegida"
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
  description = "Usuario al que pertenece del recurso"
}

variable "TAG_TEAM" {
  type        = string
  description = "Team al que pertenece el recurso"
}

variable "TAG_DESCRIPTION" {
  type        = string
  description = "Descripcion del recurso"
}

variable "TAG_TERRAFORM_PROJECT" {
  type    = string
  default = "aws-ec2-k8s"
}

variable "TAG_COMMENT" {
  type    = string
  default = "Creado usando IaC con Terraform"
}

variable "DESIRED_AMI" {
  type        = string
  description = "Nombre amigable de la AMI deseada"
}

variable "INSTANCE_LIST" {
  type = list(object({
    count = number
    desired_ami = string
  }))
}


variable "AMIS" {
  type = map(object({
    short_name = string
    owners = string
    name_pattern = string
    default_user = string
    product_code = string
  }))
  default = {
    "Amazon Linux" = {
      short_name = "amzn"
      owners = "137112412989"
      name_pattern = "amzn-ami-hvm-????.??.*.????????-x86_64-gp2"
      default_user = "ec2-user"
      product_code = null
    }
    "Amazon Linux 2" = {
      short_name = "amzn2"
      owners = "137112412989"
      name_pattern = "amzn2-ami-hvm-2.0.????????-x86_64-gp2"
      default_user = "ec2-user"
      product_code = null
    }
    "Ubuntu Server 18.04" = {
      short_name = "ubuntu18.04"
      owners = "099720109477"
      name_pattern = "ubuntu/images/*/ubuntu-bionic-18.04-amd64-server-*"
      default_user = "ubuntu"
      product_code = null
    }
    "CentOS 7" = {
      short_name = "centos7"
      owners = "aws-marketplace"
      name_pattern = null
      default_user = "centos"
      product_code = "aw0evgkw8e5c1q413zgy5pjce"
    }
  }
}

variable "INSTANCE_TYPE" {
  type    = string
  default = "t3a.micro"
}

variable "SUBNET_ID" {
  type        = string
  description = "ID de subnet deseada"
}

variable "KEY_NAME" {
  type        = string
  description = "Keypair SSH a asociar a la instancia"
}

variable "SECURITY_GROUP_IDS" {
  type        = list
  description = "Security Groups a asociar a la instancia"
}

variable "IAM_INSTANCE_PROFILE" {
  type        = string
  description = "Rol IAM a aplicar a la instancia"
}
