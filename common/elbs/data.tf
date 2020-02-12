data "aws_acm_certificate" "name" {
  domain      = "*.${var.domainname}"
  statuses    = ["ISSUED"]
  most_recent = true
}

data "aws_s3_bucket" "accesslogs" {
  bucket = "cpt-${var.cpt-tags["projectname"]}-elb-access-logs-${var.cpt-tags["environment"]}"
}
