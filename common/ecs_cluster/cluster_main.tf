resource "aws_ecs_cluster" "main" {
  name = "${var.name}"
}

output "ecs_cluster_id" {
  value = "${aws_ecs_cluster.main.id}"
}

output "ecs_cluster_name" {
  value = "${aws_ecs_cluster.main.name}"
}

resource "aws_cloudwatch_log_group" "ecs_agent" {
  name              = "${var.log_group}"
  retention_in_days = "${var.log_groups_expiration_days}"
}

resource "aws_autoscaling_group" "app" {
  name                 = "${aws_ecs_cluster.main.name}"
  enabled_metrics      = ["${var.asg_enabled_metrics}"]
  launch_configuration = "${aws_launch_configuration.app.name}"
  termination_policies = ["${var.asg_termination_policies}"]
  min_size             = "${var.asg_min_size}"
  max_size             = "${var.asg_max_size}"
  vpc_zone_identifier  = ["${var.vpc_zone_identifier}"]
  default_cooldown     = "${var.asg_default_cooldown}"
  //tags                 = ["${var.asg_extra_tags}"]
 
  lifecycle {
    create_before_destroy = true

    # NOTE: changed automacally by autoscale policy
    ignore_changes = ["desired_capacity"]
  }

  tags = [

    {
      key                 = "asg"
      vaule               = var.asg_extra_tags
      propogate_at_launch = "true"
    },
    {
      key                 = "environment"
      value               = "${lower(var.cpt-tags["environment"])}"
      propagate_at_launch = "true"
    },
    {
      key                 = "billing"
      value               = "${lower(var.cpt-tags["billing"])}"
      propagate_at_launch = "true"
    },
    {
      key                 = "owner"
      value               = "${lower(var.cpt-tags["owner"])}"
      propagate_at_launch = "true"
    },
    {
      key                 = "lob"
      value               = "${lower(var.cpt-tags["lob"])}"
      propagate_at_launch = "true"
    },
    {
      key                 = "compliance"
      value               = "${lower(var.cpt-tags["compliance"])}"
      propagate_at_launch = "true"
    },
    {
      key                 = "dataclass"
      value               = "${lower(var.cpt-tags["dataclass"])}"
      propagate_at_launch = "true"
    },
    {
      key                 = "projectname"
      value               = "${lower(var.cpt-tags["projectname"])}"
      propagate_at_launch = "true"
    },
    {
      key                 = "drtier"
      value               = "${lower(var.cpt-tags["drtier"])}"
      propagate_at_launch = "true"
    },
  ]
}

resource "aws_launch_configuration" "app" {
  ##name = "${aws_ecs_cluster.main.name}-launchconfig"
  name_prefix     = "${aws_ecs_cluster.main.name}-"
  security_groups = ["${var.security_groups}"]
  key_name        = "${var.key_name}"
  image_id        = "${var.ami_id}"
  instance_type   = "${var.instance_type}"
  ebs_optimized   = "${var.ebs_optimized}"

  root_block_device {
    volume_size = 100
  }

  iam_instance_profile = "${aws_iam_instance_profile.ecs_instance.name}"
  user_data            = "${var.user_data}"
  enable_monitoring    = true

  lifecycle {
    create_before_destroy = true
  }
}
