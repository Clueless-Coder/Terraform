output "target_group_arns" {
  value       = ["${aws_alb_target_group.alb_target_group.arn}"]
  description = "arns of the target groups"
}
