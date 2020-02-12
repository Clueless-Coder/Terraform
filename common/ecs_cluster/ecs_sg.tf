###Owner: Vpt-Devops
###Description: AWS ECS Security Groups

resource "aws_security_group" "nginxsg" {
  name = var.nginxsg
  vpc_id = var.vpc_id

  
}

resource "aws_security_group" "load_balancers" {
  name        = "${var.vpc_name}-INTERNAL-ECS-ELB"
  description = "Internal ECS ELB security group"
  vpc_id      = "${var.vpcid}"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
    description = "WEX ADDRESS"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["172.16.0.0/12"]
    description = "WEX ADDRESS"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["192.168.0.0/16"]
    description = "WEX ADDRESS"
  }

  ###NGINX security group

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = var.nginxsg
  }
  /*
    ingress {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["10.161.0.0/16"]
      description = "AOC IP"
    }

    ingress {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["10.178.32.0/21"]
      description = "AOC IP"
    }

    ingress {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["10.10.0.0/16"]
      description = "AOC IP"
    }
  ingress {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["10.212.0.0/16"]
    }
    # TODO: this probably only needs egress to the ECS security group.
    /* egress {
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          cidr_blocks = ["0.0.0.0/0"]
        }
      */
  tags {
    Name        = "${var.vpc_name}-INTERNAL-ECS-ELB"
    Environment = "${lower(var.cpt-tags["environment"])}"
    Billing     = "${lower(var.cpt-tags["billing"])}"
    Owner       = "${lower(var.cpt-tags["owner"])}"
    LOB         = "${lower(var.cpt-tags["lob"])}"
    Compliance  = "${lower(var.cpt-tags["compliance"])}"
    DataClass   = "${lower(var.cpt-tags["dataclass"])}"
    ProjectName = "${lower(var.cpt-tags["projectname"])}"
    DRTier      = "${lower(var.cpt-tags["drtier"])}"
  }
  lifecycle {
    create_before_destroy = true
  }
}


######security group rule for ELB outbound#####

resource "aws_security_group_rule" "ecselb" {
  type                     = "egress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = "${aws_security_group.load_balancers.id}"
  source_security_group_id = "${aws_security_group.ecs.id}"
  description              = "To ECS Internal"
}

#####security group for ECS
resource "aws_security_group" "ecs" {
  name = "${var.vpc_name}-INTERNAL-ECS"
  
  #name        = "vpt-ecs-sg"
  description = "Internal ECS security group"

  # vpc_id      = "${var.vpc_environment_id}"
  vpc_id = "${var.vpcid}"

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = ["${aws_security_group.load_balancers.id}"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["172.16.0.0/12"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["192.168.0.0/16"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  #######Will be needed for IAM roles to get temp credentials and to comm. with other microservices
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name        = "${var.vpc_name}-INTERNAL-ECS"
    Environment = "${lower(var.cpt-tags["environment"])}"
    Billing     = "${lower(var.cpt-tags["billing"])}"
    Owner       = "${lower(var.cpt-tags["owner"])}"
    LOB         = "${lower(var.cpt-tags["lob"])}"
    Compliance  = "${lower(var.cpt-tags["compliance"])}"
    DataClass   = "${lower(var.cpt-tags["dataclass"])}"
    ProjectName = "${lower(var.cpt-tags["projectname"])}"
    DRTier      = "${lower(var.cpt-tags["drtier"])}"
  }

  lifecycle {
    create_before_destroy = true
  }
}




output "ecs_sg_id" {
  value = "${aws_security_group.ecs.id}"
}


output "load_balancers_sg_id" {
  value = "${aws_security_group.load_balancers.id}"
}