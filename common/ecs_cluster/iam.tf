resource "aws_iam_role" "ecs_instance" {
  name                  = "${aws_ecs_cluster.main.name}-ecs-instance-role"
  force_detach_policies = true

  description        = "${aws_ecs_cluster.main.name}-ecs-instance-role"
  assume_role_policy = "${file("../common/policies/ecs-instance-role.json")}"
}

resource "aws_iam_role_policy_attachment" "ecs_instance_policy" {
  count = "${length(var.iam_policy_arns)}"

  role       = "${aws_iam_role.ecs_instance.name}"
  policy_arn = "${element(var.iam_policy_arns, count.index)}"

  depends_on = ["aws_iam_role.ecs_instance"]
}

resource "aws_iam_instance_profile" "ecs_instance" {
  name = "${aws_ecs_cluster.main.name}-ecs-instance-profile"
  role = "${aws_iam_role.ecs_instance.name}"

  depends_on = ["aws_iam_role.ecs_instance"]
}

#### attaching an  IAM role for Cloudwatch agent ##############
resource "aws_iam_role_policy_attachment" "cloudwatch" {
  role       = "${aws_iam_role.ecs_instance.name}"
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}
