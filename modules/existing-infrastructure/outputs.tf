output "vpc_id" {
  value = "${data.aws_vpc.selected.id}"
}

output "uno" {
  value = "uno"
}

output "dos" {
  value = {
    nombre   = "angel"
    apellido = "rengifo"
  }
}
