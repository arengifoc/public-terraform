output "eks-version" {
  value       = aws_eks_cluster.eks-cluster.version
  description = "Version de k8s instalada en el cluster EKS"
}

output "config_map_aws_auth" {
  value = local.config_map_aws_auth
}

output "kubeconfig" {
  value = local.kubeconfig
}