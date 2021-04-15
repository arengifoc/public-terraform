output "saphana_private_ips" {
  value = module.sap_hana.private_ips
}

output "sapnwas_private_ips" {
  value = module.sap_nw_as.private_ips
}

output "bastion_public_ips" {
  value = module.bastion.public_ips
}
