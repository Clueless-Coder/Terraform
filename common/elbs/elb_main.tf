# Public  ELB
resource "aws_alb" "ecs_services_alb" {
  #name                             = "${var.service_name}-elb"
  name                             = "${replace(var.service_name, ".", "-")}-elb"
  subnets                          = ["${var.public_subnet_ids}"]
  security_groups                  = ["${var.security_groups}"]
  enable_cross_zone_load_balancing = true
  internal                         = "${var.elbinternal}"

  access_logs {
    bucket  = "${data.aws_s3_bucket.accesslogs.bucket}"
    prefix  = "${replace(var.service_name, ".", "-")}"
    enabled = true
  }
  idle_timeout="${var.idle_timeout}"
  ####adding tags
  tags {
    Name        = "${var.service_name}-elb"
    billing     = "${var.cpt-tags["billing"]}"
    projectname = "${var.cpt-tags["projectname"]}"
    owner       = "${var.cpt-tags["owner"]}"
    environment = "${var.cpt-tags["environment"]}"
    lob         = "${var.cpt-tags["lob"]}"
    compliance  = "${var.cpt-tags["compliance"]}"
    dataclass   = "${var.cpt-tags["dataclass"]}"
    drtier      = "${var.cpt-tags["drtier"]}"
  }
}

resource "aws_alb_listener" "ecs_service_listener" {
  load_balancer_arn = "${aws_alb.ecs_services_alb.arn}"
  port              = "${var.elb_port}"
  protocol          = "HTTPS"
  certificate_arn   = "${data.aws_acm_certificate.name.arn}"

  default_action {
    target_group_arn = "${aws_alb_target_group.alb_target_group.arn}"
    type             = "forward"
  }
}

resource "aws_alb_target_group" "alb_target_group" {
  name     = "${replace(var.service_name, ".", "-")}-tg"
  port     = "${var.target_group_port}"
  protocol = "HTTP"
  vpc_id   = "${var.vpcid}"

  stickiness {
    type            = "lb_cookie"
    cookie_duration = "${var.cookie_duration}"
    enabled         = "${var.stickiness_enabled}"
  }

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 10
    timeout             = 5
    interval            = 10
    path                = "${var.target_group_path}"
    port                = "${var.port}"
  }
}

output "ecs_services_elb_id" {
  value = "${aws_alb.ecs_services_alb.id}"
}

resource "aws_route53_record" "dns_record" {
  count = "${var.elbinternal ? 1 : 0}"

  zone_id = "${var.dns_zone_id}"
  name    = "${var.service_name}.${var.sub-domain}"
  type    = "A"

  alias {
    name                   = "${aws_alb.ecs_services_alb.dns_name}"
    zone_id                = "${aws_alb.ecs_services_alb.zone_id}"
    evaluate_target_health = true
  }
}

/*
resource "aws_elb" "ecs_services_elb" {
  name            = "${var.service_name}"
  subnets         = ["${var.public_subnet_ids}"]
  security_groups = ["${var.security_groups}"]

  listener {
    instance_port     = "${var.ecs_instance_port}"
    instance_protocol = "http"
    lb_port           = "${var.elb_port}"
    lb_protocol       = "http"
  }

  
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3

    ##target              = "HTTP:80/healthcheck.php"
    target = "${var.elb_target}"

    interval = 30
  }
  ##  instances                   = ["${aws_instance.foo.id}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400
  tags {
    Name = "${var.service_name}"

    ####adding tags
    billing     = "${var.cpt-tags["billing"]}"
    projectname = "${var.cpt-tags["projectname"]}"
    owner       = "${var.cpt-tags["owner"]}"
    environment = "${var.cpt-tags["environment"]}"
    lob         = "${var.cpt-tags["lob"]}"
    compliance  = "${var.cpt-tags["compliance"]}"
    dataclass   = "${var.cpt-tags["dataclass"]}"
    drtier      = "${var.cpt-tags["drtier"]}"
  }
}

output "ecs_services_elb_id" {
  value = "${aws_elb.ecs_services_elb.id}"
}
*/

