# Detalles del proveedor a usar. Se hace uso de variables, las
# mismas que son definidas y asignadas en otros archivos.
provider "aws" {
    # Access Key ID
    access_key = "${var.AWS_ACCESS_KEY}"

    # Secret Key
    secret_key = "${var.AWS_SECRET_KEY}"

    # Region donde se debe crear los recursos
    region = "${var.AWS_REGION}"
}
