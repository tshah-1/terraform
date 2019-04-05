resource "aws_iam_user" "gernotheschl" {
  name = "gernot.heschl"
  path = "/"
}

resource "aws_iam_user" "chrismuzyunda" {
  name = "chris.muzyunda"
  path = "/"
}

resource "aws_iam_user" "bernddielacher" {
  name = "bernd.dielacher"
  path = "/"
}

resource "aws_iam_user" "bostjanbele" {
  name = "bostjan.bele"
  path = "/"
}

resource "aws_iam_user" "haraldsaringer" {
  name = "harald.saringer"
  path = "/"
}

resource "aws_iam_user" "volkerhutten" {
  name = "volker.hutten"
  path = "/"
}

resource "aws_iam_user" "christianmarko" {
  name = "christian.marko"
  path = "/"
}

resource "aws_iam_group" "admin-users" {
  name = "admin-users"
  path = "/"
}

resource "aws_iam_group_membership" "admin-user-membership" {
  name = "admin-user-membership"

  users = [
    "${aws_iam_user.gernotheschl.name}",
    "${aws_iam_user.chrismuzyunda.name}",
    "${aws_iam_user.bernddielacher.name}",
    "${aws_iam_user.bostjanbele.name}",
    "${aws_iam_user.haraldsaringer.name}",
    "${aws_iam_user.volkerhutten.name}",
    "${aws_iam_user.christianmarko.name}",
  ]

  group = "${aws_iam_group.admin-users.name}"
}

resource "aws_iam_group_policy" "explicit-admin" {
  name  = "explicit-admin"
  group = "${aws_iam_group.admin-users.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "*",
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

