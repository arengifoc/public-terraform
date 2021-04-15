resource "aws_iam_user" "user" {
  count = "${length(var.usuarios)}"
  name = "${element(var.usuarios,count.index)}"
  path = "/"
  force_destroy = true
}

#resource "aws_iam_access_key" "user" {
  #user = "${aws_iam_user.user.name}"
#}

#resource "aws_iam_user_policy" "lb_ro" {
  #name = "test"
  #user = "${aws_iam_user.lb.name}"
#
  #policy = <<EOF
#{
  #"Version": "2012-10-17",
  #"Statement": [
    #{
      #"Action": [
        #"ec2:Describe*"
      #],
      #"Effect": "Allow",
      #"Resource": "*"
    #}
  #]
#}
#EOF
#}

#output "KeyID" {
  #value = "${aws_iam_access_key.user01.id}"
#}

#output "SecretKey" {
  #value = "${aws_iam_access_key.user01.secret}"
#}
