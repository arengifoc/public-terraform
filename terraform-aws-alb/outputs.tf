output "lblogs_bucket_name" {
  value = aws_s3_bucket.lblogs_bucket.id
}

output "lblogs_bucket_arn" {
  value = aws_s3_bucket.lblogs_bucket.arn
}

output "alb_dns_name" {
  value = aws_lb.alb.dns_name
}

output "alb_dns_arn" {
  value = aws_lb.alb.arn
}
