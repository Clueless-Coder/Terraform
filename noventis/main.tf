###elbs
module "ss01_elb" {
  source            = "../common/elbs"
  public_subnet_ids = ["${split(",", "${module.vpc.private_subnet_ids}")}"]
  security_groups   = ["${module.ecs_cluster.load_balancers_sg_id}"]
  service_name      = "sampleservice01"
  sub-domain        = "sample"
  dns_zone_id       = "${module.wexgen_route53.zone_id}"
  elb_port          = 443
  domainname        = "${var.domainname}"
  elbinternal       = true
  target_group_port = "8090"
  target_group_path = "/index.html"
  vpcid             = "${var.vpcid}"

  cpt-tags = {
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

## ecs clsuter
module "ecs_cluster" {
  source              = "../common/ecs_cluster"
  vpc_name            = "${var.vpc_name}"
  nginxsg             = "${module.wexgen_nginx.nginx_elb_sg_id}"
  key_name            = "${var.key_name}"
  ami_id              = "${data.aws_ami.ecs.id}"
  instance_type       = "c5.xlarge"
  vpc_zone_identifier = ["${split(",", "${module.vpc.private_subnet_ids}")}"]
  vpcid               = "${var.vpcid}"
  security_groups     = ["${module.ecs_cluster.ecs_sg_id}"]
  #ebs_optimized               = true
  name = "${var.ecs_cluster_name}"

  user_data = <<-EOF
                #!/bin/bash
                docker plugin install store/sumologic/docker-logging-driver:1.0.2 --alias sumologic --grant-all-permissions
                echo ECS_CLUSTER="${var.ecs_cluster_name}" >> /etc/ecs/ecs.config
                echo ECS_AVAILABLE_LOGGING_DRIVERS='["sumologic","awslogs"]' >> /etc/ecs/ecs.config
                                 
              EOF

  asg_min_size = 6
  asg_max_size = 20
  asg_extra_tags = [
    {
      key                 = "Name"
      value               = "${var.ecs_cluster_name}-asg"
      propagate_at_launch = true
    },
  ]

  autoscale_thresholds = {
    memory_reservation_high = 75
    memory_reservation_low  = 25

  }

  log_group                  = "${var.ecs_cluster_name}/ecs-agent"
  log_groups_expiration_days = 30
  #arx-admin-webapp-public-ip = "${var.arx-admin-webapp-public-ip}"

  cpt-tags = {
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

### RDS cluster

module "rds" {
  source                    = "../common/rds"
  vpcid                     = "${var.vpcid}"
  vpc_name                  = "${var.vpc_name}"
  datalayer_subnet_ids      = ["${split(",","${module.vpc.DataLayer_subnets_ids}")}"]
  datalayer_security_groups = ["${module.rds.datalayer_sg_ids}"]
  secgroup2                 = ["${module.vpc.private_sg_id}"]
  sg02                      = ["${module.rebates_informatica.informatica_sg_id}"]

  cpt-tags = {
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
