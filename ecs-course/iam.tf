data "aws_iam_policy_document" "this_ec2" {
  statement {
    sid     = "ec2InstanceRole"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    effect = "Allow"
  }
}

resource "aws_iam_role" "this_ec2" {
  name               = "acancino-ec2-role"
  path               = "/"
  description        = "Allows EC2 instances to call AWS services on your behalf"
  assume_role_policy = data.aws_iam_policy_document.this_ec2.json
}

data "aws_iam_policy_document" "this_ecs" {
  statement {
    sid     = "ecsRole"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    effect = "Allow"
  }
}

resource "aws_iam_role" "this_ecs" {
  name               = "acancino-ecs-role"
  path               = "/"
  description        = "Allows ECS to create and manage AWS resources on your behalf"
  assume_role_policy = data.aws_iam_policy_document.this_ec2.json
}

resource "aws_iam_instance_profile" "this_ec2" {
  name_prefix = "acancino-ec2-instance-profile"
  role        = aws_iam_role.this_ec2.id
}

data "aws_iam_policy" "ecs_for_ec2" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

data "aws_iam_policy" "s3" {
  arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "ecs_for_ec2" {
  role       = aws_iam_role.this_ec2.name
  policy_arn = data.aws_iam_policy.ecs_for_ec2.arn
}

resource "aws_iam_role_policy_attachment" "s3" {
  role       = aws_iam_role.this_ec2.name
  policy_arn = data.aws_iam_policy.s3.arn
}

data "aws_iam_policy" "ecs" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}

resource "aws_iam_role_policy_attachment" "ecs" {
  role       = aws_iam_role.this_ecs.name
  policy_arn = data.aws_iam_policy.ecs.arn
}
