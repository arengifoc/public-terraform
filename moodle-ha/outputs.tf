output "public_ip" {
  value = module.moodle_ami.public_ip
}

output "ceph_nodes_public" {
  value = module.ceph.public_ip
}

output "ceph_nodes_private" {
  value = module.ceph.private_ip
}