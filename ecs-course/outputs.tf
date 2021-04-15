output "security_group_id" {
  value = aws_security_group.this.id
}

output "key_pair_name" {
  value = aws_key_pair.this.key_name
}

output "ec2_iam_role_id" {
  value = aws_iam_role.this_ec2.id
}

output "ec2_iam_role_arn" {
  value = aws_iam_role.this_ec2.arn
}

output "ecs_iam_role_id" {
  value = aws_iam_role.this_ecs.id
}

output "ecs_iam_role_arn" {
  value = aws_iam_role.this_ecs.arn
}

output "ecs_cluster_id" {
  value = aws_ecs_cluster.this.id
}

output "s3_bucket_id" {
  value = aws_s3_bucket.this.id
}

output "instance_id" {
  value = module.ec2.id
}

output "instance_private_ip" {
  value = module.ec2.private_ip
}

output "ecr_repository_name" {
  value = aws_ecr_repository.this_nginx.name
}

output "ecr_repository_repository_url" {
  value = aws_ecr_repository.this_nginx.repository_url
}
