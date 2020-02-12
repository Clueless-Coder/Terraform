#################################################################
###Owner: Vpt-Devops
###Description: AWS RDS DB Instance
#################################################################
resource "aws_db_subnet_group" "rds_subnet_group" {
  name        = "wex-cpt-rebates-dev-rds-subnet-group"
  description = "Our main group of subnets"
  subnet_ids  = ["${var.datalayer_subnet_ids}"]
}

resource "aws_db_instance" "informatica-rds" {
  allocated_storage       = 20                                      # gigabytes
  backup_retention_period = 7                                       # in days
  db_subnet_group_name    = "wex-cpt-rebates-dev-rds-subnet-group"
  engine                  = "oracle-ee"
  engine_version          = "12.1.0.2.v6"
  identifier              = "informatica"
  instance_class          = "db.t2.medium"
  multi_az                = false
  name                    = "informat"
  password                = "Dev1Informatica12#"
  port                    = 1521
  publicly_accessible     = false
  storage_encrypted       = true                                    # you should always do this
  storage_type            = "gp2"
  username                = "devopsroot"
  vpc_security_group_ids  = ["${var.datalayer_security_groups}"]
  parameter_group_name    = "default.oracle-ee-12.1"

  #skip_final_snapshot      = true
  tags {
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

resource "aws_db_instance" "rebates-rds" {
  allocated_storage       = 1000                                   # gigabytes
  backup_retention_period = 7                                       # in days
  db_subnet_group_name    = "wex-cpt-rebates-dev-rds-subnet-group"
  engine                  = "oracle-ee"
  engine_version          = "12.1.0.2.v6"
  identifier              = "rebates"
  instance_class          = "db.t2.large"
  multi_az                = false
  name                    = "rebates"
  password                = "Dev1Rebates12#"
  port                    = 1521
  publicly_accessible     = false
  storage_encrypted       = true                                    # you should always do this
  storage_type            = "gp2"
  username                = "devopsroot"
  vpc_security_group_ids  = ["${var.datalayer_security_groups}"]
  parameter_group_name    = "default.oracle-ee-12.1"

  #skip_final_snapshot      = true
  tags {
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
