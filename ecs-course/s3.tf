resource "aws_s3_bucket" "this" {
  bucket_prefix = var.s3_bucket_prefix
  tags          = var.tags
  force_destroy = true
}

resource "aws_s3_bucket_object" "name" {
  bucket     = aws_s3_bucket.this.id
  key        = "ecs.config"
  acl        = "private"
  source     = "templates/ecs.config"
  depends_on = [local_file.this]
}

resource "local_file" "this" {
  content = templatefile(
    "${path.module}/templates/ecs.config.tpl",
    {
      cluster_name = "${var.name_prefix}-cluster"
    }
  )
  filename = "${path.module}/templates/ecs.config"
}
