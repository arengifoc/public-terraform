resource "aws_ecs_cluster" "this" {
  name = "${var.name_prefix}-cluster"
  tags = var.tags
}

resource "aws_ecs_task_definition" "this_web" {
  family = "${var.name_prefix}-web"
  container_definitions = templatefile(
    "${path.module}/templates/web-task-definition.json.tpl",
    {
      repository_url = "${aws_ecr_repository.this_nginx.repository_url}:1.18",
    }
  )
  memory       = 1024
  network_mode = "bridge"
  # task_role_arn = "arn:aws:iam::539048538220:role/AWX_Test"
}

# resource "aws_ecs_service" "ror_web_service" {
#   name            = "ror_web_service"
#   cluster         = aws_ecs_cluster.this.id
#   task_definition = aws_ecs_task_definition.ror_web.arn
#   desired_count   = 1
# }

resource "aws_ecr_repository" "this_nginx" {
  name = "${var.name_prefix}/nginx"
}
