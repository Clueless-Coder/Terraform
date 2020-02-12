#### IAM role for app autoscaling##########

data "aws_iam_role" "appautoscaling" {
  name = "AWSServiceRoleForApplicationAutoScaling_ECSService"
}

resource "aws_appautoscaling_target" "ecs_target" {
  #max_capacity       = 10
  max_capacity = "${var.maxsize}"
  min_capacity = "${var.minsize}"

  #min_capacity       = 1
  resource_id        = "service/local.cluster_name/${var.service_name}"
  role_arn           = "${data.aws_iam_role.appautoscaling.arn}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
  depends_on         = ["aws_ecs_service.main"]
}

resource "aws_appautoscaling_policy" "ecs_targettracking_memory" {
  name               = "${var.service_name}-memory"
  resource_id        = "service/local.cluster_name/${var.service_name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
  policy_type        = "TargetTrackingScaling"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value       = 75
    scale_in_cooldown  = 60
    scale_out_cooldown = 60
  }

  depends_on = ["aws_appautoscaling_target.ecs_target"]
}

resource "aws_appautoscaling_policy" "ecs_targettracking_cpu" {
  name               = "${var.service_name}-cpu"
  resource_id        = "service/local.cluster_name/${var.service_name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
  policy_type        = "TargetTrackingScaling"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value       = 75
    scale_in_cooldown  = 60
    scale_out_cooldown = 60
  }

  depends_on = ["aws_appautoscaling_target.ecs_target"]
}
