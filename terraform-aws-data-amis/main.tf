data "aws_ami" "selected" {
  dynamic "filter" {
    for_each = var.amis[var.os].name_pattern == null ? [] : [1]
    content {
      name   = "name"
      values = [var.amis[var.os].name_pattern]
    }
  }

  dynamic "filter" {
    for_each = var.amis[var.os].product_code == null ? [] : [1]
    content {
      name   = "product-code"
      values = [var.amis[var.os].product_code]
    }
  }

  filter {
    name   = "root-device-type"
    values = [var.amis[var.os].disk_type]
  }

  most_recent = true
  owners      = [var.amis[var.os].owners]
}
