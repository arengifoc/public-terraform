output "default_user" {
  description = "Default SSH user of the EC2 instance"
  value       = var.ami_id != "" ? var.default_user : module.ami.default_user
}

output "instance_ids" {
  description = "IDs of the EC2 instances"
  value       = module.ec2.id
}

output "instance_keypair" {
  description = "Name of the SSH keypair attached to the EC2 instances"
  value       = aws_key_pair.this[0].key_name
}

output "instance_private_ips" {
  description = "Private IP addresses assigned to the EC2 instances"
  value       = module.ec2.private_ip
}

output "instance_public_ips" {
  description = "Public IP addresses assigned to the EC2 instances"
  value       = module.ec2.public_ip
}

output "instance_names" {
  description = "Name of the EC2 instances as per the Name tag"
  value       = [for tag in module.ec2.tags : lookup(tag, "Name", "")]
}
