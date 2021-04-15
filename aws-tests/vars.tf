variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}
variable "AWS_REGION" {
    default = "us-east-1"
}
variable "AMIS_UBUNTU" {
    type = "map"
    default = {
        # Ubuntu Server 18.04 LTS (HVM), SSD Volume Type
        us-east-1 = "ami-0ac019f4fcb7cb7e6"
        # Ubuntu Server 18.04 LTS (HVM), SSD Volume Type
        us-east-2 = "ami-0f65671a86f061fcd"
    }
}
variable "AMIS_WINDOWS" {
    type = "map"
    default = {
        # Microsoft Windows Server 2016 Base en N. Virginia
        us-east-1 = "ami-041114ddee4a98333"
    }
}
variable "OS_USER" {
    default = "ec2-user"
}
variable "PRIVATE_KEY" {
    default = "id_rsa"
}
variable "PUBLIC_KEY" {
    default = "id_rsa.pub"
}
