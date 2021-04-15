variable "AWS_PROFILE" {
  type        = string
  description = "Perfil AWS CLI elegido"
}

variable "REGION" {
  type        = string
  description = "Region elegida"
  default     = "us-east-1"
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

variable "APP_NAME" {
  type        = string
  description = "Nombre de la aplicacion"
}

variable "APP_DESCRIPTION" {
  type        = string
  description = "Descripcion de la aplicacion"
}

variable "MAX_VERSIONS" {
  type        = number
  description = "Cantidad maxima de versiones de la aplicacion a guardar"
}

variable "AMIS_VIRGINIA" {
  type        = map
  description = "Lista de AMIs de uso comun en Virginia"
  default = {
    # Amazon Linux 2 x86_64
    amazon2 = "ami-062f7200baf2fa504"
    # Ubuntu Server 18.04 x86_64
    ubuntu = "ami-04b9e92b5572fa0d1"
  }
}

variable "INSTANCE_TYPE" {
  type    = string
  default = "t3a.micro"
}

variable "SERVICE_ROLE" {
  type        = string
  description = "Rol que asume Beanstalk para eliminar versiones de aplicaciones"
  default     = "arn:aws:iam::104314781943:role/aws-service-role/elasticbeanstalk.amazonaws.com/AWSServiceRoleForElasticBeanstalk"

}

variable "SUBNET_ID" {
  type        = string
  description = "ID de subnet deseada"
  default     = ""
}

variable "KEY_NAME" {
  type        = string
  description = "Keypair SSH a asociar a la instancia"
  default     = ""
}

variable "SECURITY_GROUP_IDS" {
  type        = list
  description = "Security Groups a asociar a la instancia"
  default     = []
}
