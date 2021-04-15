# Outputs para exportar info que se capture luego con terraform_remote_state
output "eks-cluster-name" {
  value       = var.EKS_CLUSTER_NAME
  description = "Nombre del cluster EKS"
}

output "sg-id" {
  value       = aws_security_group.sg-eks.id
  description = "ID del security group"
}

output "subnet-ids" {
  value       = aws_subnet.subnets-eks.*.id
  description = "ID de subnets"
}

output "vpc-id" {
  value       = aws_vpc.vpc-eks.id
  description = "ID de la VPC"
}
