output "network_info" {
  value = <<EOF

IP(s) publica(s): ${join(" ", aws_instance.ec2instance.*.public_ip)}
IP(s) privada(s): ${join(" ", aws_instance.ec2instance.*.private_ip)}
Usuario de acceso: ${var.amis[var.desired_os].default_user}
EOF
}
