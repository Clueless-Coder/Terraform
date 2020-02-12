# Our default security group to access
# the instances over SSH and HTTP
resource "aws_security_group" "rds_sg" {
  name        = "${var.vpc_name}-RDS-SG01"
  description = "Used in the terraform"

  #vpc_id      = "${var.vpc_environment_id}"
  vpc_id = "${var.vpcid}"

  # PostgreSQL access from anywhere
  ingress {
    from_port   = 1521
    to_port     = 1521
    protocol    = "tcp"
    cidr_blocks = ["208.64.192.0/21"]
  }

  ingress {
    from_port   = 1521
    to_port     = 1521
    protocol    = "tcp"
    cidr_blocks = ["24.39.43.218/32"]
  }

  ingress {
    from_port   = 1521
    to_port     = 1521
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  ingress {
    from_port   = 1521
    to_port     = 1521
    protocol    = "tcp"
    cidr_blocks = ["172.16.0.0/12"]
  }

  ingress {
    from_port   = 1521
    to_port     = 1521
    protocol    = "tcp"
    cidr_blocks = ["192.168.0.0/16"]
  }

  ingress {
    from_port       = 1521
    to_port         = 1521
    protocol        = "tcp"
    security_groups = ["${var.secgroup2}"]
  }

  ingress {
    from_port       = 1521
    to_port         = 1521
    protocol        = "tcp"
    security_groups = ["${var.sg02}"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name        = "${var.vpc_name}-RDS-SG01"
    Environment = "${lower(var.cpt-tags["environment"])}"
    Billing     = "${lower(var.cpt-tags["billing"])}"
    Owner       = "${lower(var.cpt-tags["owner"])}"
    LOB         = "${lower(var.cpt-tags["lob"])}"
    Compliance  = "${lower(var.cpt-tags["compliance"])}"
    DataClass   = "${lower(var.cpt-tags["dataclass"])}"
    ProjectName = "${lower(var.cpt-tags["projectname"])}"
    DRTier      = "${lower(var.cpt-tags["drtier"])}"
  }
}

output "datalayer_sg_ids" {
  value = "${aws_security_group.rds_sg.id}"
}
