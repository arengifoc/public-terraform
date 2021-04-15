# declaracion del proveedor a usar
provider "aws" {
    access_key = "${var.AWS_ACCESS_KEY}" # Access key ID
    secret_key = "${var.AWS_SECRET_KEY}" # Secret key
    region = "${var.AWS_REGION}"
}
