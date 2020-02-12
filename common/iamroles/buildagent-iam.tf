#### IAM role for build agent with Administrative permissions####
/*
data "aws_iam_policy_document" "admin" {
  statement {
    actions   = ["*"]
    resources = ["*"]
    effect    = "Allow"
  }
}

resource "aws_iam_policy" "adminpolicy" {
  name   = "BuildAdmin-access-policy"
  policy = "${data.aws_iam_policy_document.admin.json}"
}

resource "aws_iam_role" "adminrole" {
  name = "BuildAdminRole"

  assume_role_policy = <<EOF
  {
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "admin" {
  role       = "${aws_iam_role.adminrole.name}"
  policy_arn = "${aws_iam_policy.adminpolicy.arn}"
}
*/