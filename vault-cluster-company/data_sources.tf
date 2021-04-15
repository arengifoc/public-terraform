data "aws_vpc" "primary_selected" {
  provider = aws.primary
  id       = var.primary_vpc_id
}

data "aws_subnet" "primary_private" {
  provider = aws.primary
  for_each = toset(local.primary_private_subnet_ids)
  id       = each.value
}

data "aws_subnet" "primary_public" {
  provider = aws.primary
  for_each = toset(local.primary_public_subnet_ids)
  id       = each.value
}

data "aws_vpc" "secondary_selected" {
  count    = length(var.secondary_vpc_id) > 5 && var.secondary_vpc_id != null ? 1 : 0
  provider = aws.secondary
  id       = var.secondary_vpc_id
}

data "aws_ami" "primary_selected" {
  provider = aws.primary
  dynamic "filter" {
    for_each = var.amis[var.desired_os].name_pattern == null ? [] : [1]
    content {
      name   = "name"
      values = [var.amis[var.desired_os].name_pattern]
    }
  }

  dynamic "filter" {
    for_each = var.amis[var.desired_os].product_code == null ? [] : [1]
    content {
      name   = "product-code"
      values = [var.amis[var.desired_os].product_code]
    }
  }

  filter {
    name   = "root-device-type"
    values = [var.amis[var.desired_os].disk_type]
  }

  most_recent = true
  owners      = [var.amis[var.desired_os].owners]
}

data "aws_ami" "secondary_selected" {
  provider = aws.secondary
  dynamic "filter" {
    for_each = var.amis[var.desired_os].name_pattern == null ? [] : [1]
    content {
      name   = "name"
      values = [var.amis[var.desired_os].name_pattern]
    }
  }

  dynamic "filter" {
    for_each = var.amis[var.desired_os].product_code == null ? [] : [1]
    content {
      name   = "product-code"
      values = [var.amis[var.desired_os].product_code]
    }
  }

  filter {
    name   = "root-device-type"
    values = [var.amis[var.desired_os].disk_type]
  }

  most_recent = true
  owners      = [var.amis[var.desired_os].owners]
}
