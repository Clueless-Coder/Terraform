variable "service_name" {
  description = "Name of ECS Service"
  default = "tomcat_service"
}

/*variable "cluster_id" {
  description = "ID (ARN) of ECS Cluster"
  default= module.ecs_cluster.cluster_id
}
*/

locals {
  cluster_name = module.ecs_cluster.cluster_name
}

variable "vpcid" {
  default = "vpc-bc1230db"
}



variable "launch_type" {
  description = "Launch type fo ECS Service"
  default = "FARGATE"
}

variable "iam_path" {
  description = "The Path of IAM Role(s)"
  default     = "/"
}

variable "iam_role_inline_policy" {
  description = "AWS ECS Service Policy at IAM Role"

  default = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:Describe*",
        "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
        "elasticloadbalancing:DeregisterTargets",
        "elasticloadbalancing:Describe*",
        "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
        "elasticloadbalancing:RegisterTargets"
      ],
      "Resource": "*"
    }
  ]
}
EOT
}

variable "placement_strategy_type" {
  description = "The type of placement strategy"
  default     = "spread"                         // or binpack (this module cannot specify "random"
}

variable "placement_strategy_field" {
  description = "The field of placement strategy valid values that U select type"
  default     = "instanceId"
}

variable "desired_count" {
  description = "The number of instances of the task definition"
  default     = 1
}

variable "deployment_maximum_percent" {
  description = "The upper limit of the number of running tasks that can be running in a service during a deployment"
  default     = 200
}

variable "deployment_minimum_healthy_percent" {
  description = "The lower limit of the number of running tasks that must remain running and healthy in a service during a deployment"
  default     = 100
}

# Application Load Balancer

##variable "target_group_arn" {
##  description = "The ARN of the ALB target group to associate with the service"
##}

# Container
variable "container_name" {
  description = "AWS containers name as related load_balancer"
  default = "tomcat"
}

variable "container_port" {
  description = "AWS containers port"
  default = "80"
}

variable "container_family" {
  description = "AWS containers family name"
  type        = "string"
  default = "tomcat_cluster"
}

variable "container_definitions" {
  description = "AWS ECS Task definitions"
  type        = "string"
  default = <<EOT
  {
    {
  "containerDefinitions": [
    {
      "memory": 264,
      "portMappings": [
        {
          "hostPort": 80,
          "containerPort": 8080,
          "protocol": "tcp"
        }
      ],
      "essential": true,
      "name": "tomcat-container",
      "image": "tomcat",
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "ecs-log-streaming",
          "awslogs-region": "us-west-2",
          "awslogs-stream-prefix": "fargate-tomcat-1"
        }
      },
      "cpu": 0
    }
  ],
  "networkMode": "awsvpc",
  "executionRoleArn": "Execution Role ARN",
  "memory": "2048",
  "cpu": "1024",
  "requiresCompatibilities": [
    "FARGATE"
  ]

}

  }
  EOT
}

#variable "log_group" {}

variable "log_groups" {
  description = "The List of CloudWatch Log Group Name for ECS Task (Container)"
  type        = "list"
  default     = []
}

/*variable "log_group_expiration_days" {
  description = "Specifies the number of days you want to retain log events"
  default     = 30
}
*/
# AutoScaling

variable "autoscale_thresholds" {
  description = "The values against which the specified statistic is compared"
  type        = "map"

  # No apply if empty
  default = {
    # Supporting thresholds as berow  #cpu_high    = // e.g. 75  #cpu_row     = // e.g.  5  #memory_high = // e.g. 75  #memory_row  = // e.g. 40
  }
}

variable "autoscale_max_capacity" {
  description = "The max capacity of the scalable target"
  default     = 1
}

variable "autoscale_min_capacity" {
  description = "The min capacity of the scalable target"
  default     = 1
}

variable "autoscale_cooldown" {
  description = "The cooldown / period for watching scale (seconds)"
  default     = 300
}

variable "scale_out_step_adjustment" {
  description = "The attributes of step scaling policy"
  type        = "map"

  default = {
    metric_interval_lower_bound = 0
    scaling_adjustment          = 1
  }
}

variable "scale_in_step_adjustment" {
  description = "The attributes of step scaling policy"
  type        = "map"

  default = {
    metric_interval_upper_bound = 0
    scaling_adjustment          = -1
  }
}

variable "scale_out_ok_actions" {
  description = "For scale-out as same as ok actions for cloudwatch alarms"
  type        = "list"
  default     = []
}

variable "scale_out_more_alarm_actions" {
  description = "For scale-out as same as alarm actions for cloudwatch alarms"
  type        = "list"
  default     = []
}

variable "scale_in_ok_actions" {
  description = "For scale-in as same as ok actions for cloudwatch alarms"
  type        = "list"
  default     = []
}

variable "scale_in_more_alarm_actions" {
  description = "For scale-in as same as alarm actions for cloudwatch alarms"
  type        = "list"
  default     = []
}

//variable "service_elb_id" {}

#variable "vpc_environment_id" {}

### varibale for ALB target group
/*
variable "elb_target_group_arn" {
  type        = "string"
  description = "ARN of target group of ALB"
}
*/
/*
variable "alb_listener_frontend" {
  description = "alb listener frontend"
}
*/

/*variable "service_name" {
  type = "string"
}
*/
variable "maxsize" {
  type        = "string"
  default     = 1
  description = "max size of the ECS app in app autoscaling"
}

variable "minsize" {
  type        = "string"
  default     = 1
  description = "min size of the ECS app in autoscaling"
}
