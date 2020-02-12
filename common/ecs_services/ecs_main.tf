
module "ecs_cluster" {
  source = "../ecs_cluster"
  
}
module "elbs" {
  source = "../elbs"
  
}


resource "aws_ecs_task_definition" "container" {
  family                = "${var.container_family}"
  container_definitions = "${var.container_definitions}"
}


resource "aws_ecs_service" "main" {
  name    = "${var.name}"
  cluster = module.ecs_cluster.cluster_id
  launch_type = var.launch_type
  ##cluster = "${aws_ecs_cluster.ecs_cluster.id}"
  task_definition = "${aws_ecs_task_definition.container.arn}"
  iam_role        = "${aws_iam_role.ecs_service.arn}"

  ######ramki iam_role = "${aws_iam_role.cluster_service_role.arn}"

  # As below is can be running in a service during a deployment
  desired_count                      = "${var.desired_count}"
  depends_on                         = ["aws_iam_role_policy.ecs_service"]
  deployment_maximum_percent         = "${var.deployment_maximum_percent}"
  deployment_minimum_healthy_percent = "${var.deployment_minimum_healthy_percent}"
  ordered_placement_strategy {
    type  = "${var.placement_strategy_type}"
    field = "${var.placement_strategy_field}"
  }
  load_balancer {
    # elb_name         = "${var.service_elb_id}"
    target_group_arn = module.elbs.target_group_arns
    container_name   = "${var.container_name}"
    container_port   = "${var.container_port}"
  }
  /* lifecycle {
                            ignore_changes = [
                              "desired_count",
                              "task_definition"
                            ]
                          }
                        */
  #depends_on = ["aws_iam_role_policy.ecs_service"]
}

resource "aws_iam_role" "ecs_service" {
  name                  = "${var.name}-ecs-service-role"
  path                  = "${var.iam_path}"
  force_detach_policies = true
  assume_role_policy    = "${file("../../common/policies/cluster-service-role.json")}"
}

resource "aws_iam_role_policy" "ecs_service" {
  name   = "${var.name}-ecs-service-policy"
  role   = "${aws_iam_role.ecs_service.name}"
  policy = "${var.iam_role_inline_policy}"

  ## policy = "${coalesce(var.cluster_service_iam_policy_contents, file("policies/cluster-service-policy.json"))}"
  ##cluster-service-policy.json
}
/*
resource "aws_cloudwatch_log_group" "app" {
  name              = "${var.log_group}"
  retention_in_days = "${var.log_group_expiration_days}"
}
*/