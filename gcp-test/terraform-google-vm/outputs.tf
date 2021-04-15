output "public_ips" {
  value = zipmap([for item in google_compute_instance.this_vm.*.id: element(split("/", item), 5)], google_compute_instance.this_vm.*.network_interface.0.access_config.0.nat_ip)
}

output "private_ips" {
  value = zipmap([for item in google_compute_instance.this_vm.*.id: element(split("/", item), 5)], google_compute_instance.this_vm.*.network_interface.0.network_ip)
}
