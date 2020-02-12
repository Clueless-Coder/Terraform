# Copyright 2016 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License"). You may not use this file
# except in compliance with the License. A copy of the License is located at
#
#     http://aws.amazon.com/apache2.0/
#
# or in the "license" file accompanying this file. This file is distributed on an "AS IS"
# BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations under the License.
variable "availability_zones" {
  # No spaces allowed between az names!
  default = "us-west-2a,us-west-2b,us-west-2c"
}

#
# From other modules
#
variable "public_subnet_ids" {
  description = "AWS security group id(s) for container instances launch configuration"
  type        = "list"
}

variable "security_groups" {
  description = "AWS security group id(s) for container instances launch configuration"
  type        = "list"
}

variable "elb_port" {
  description = "AWS elb port"
}

/*
variable "ecs_instance_port" {
  description = "ecs instance_port"
}
*/
variable "dns_zone_id" {
  description = "dns_zone_id"
}

variable "service_name" {
  description = "service_name"
}

/*
variable "elb_target" {
  description = "elb_target"
}
*/
variable "cpt-tags" {
  type = "map"

  default = {
    "billing"     = "unknown"
    "owner"       = "unknown"
    "environment" = "unknown"
    "projectname" = "unknown"
    "lob"         = "unknown"
    "compliance"  = "unknown"
    "dataclass"   = "unknown"
    "projectname" = "unknown"
    "drtier"      = "unknown"
  }
}

###adding varibales for target groups and paths###
variable "target_group_port" {
  description = "port number for target group"
}

variable "target_group_path" {
  description = "path for the target group"
}

variable "vpcid" {
  description = "the value of vpc id"
}

variable "elbinternal" {
  description = "type of application load balancer"
  default     = "false"
}

variable "port" {
  description = "traffic port or override"
  default     = "traffic-port"
}

variable "sub-domain" {
  description = "sub-domain of the service as per service"
}

variable "domainname" {}

variable "idle_timeout" {
  default = 150
}

variable "stickiness_enabled" {
  default = false
}

variable "cookie_duration" {
  default = 86400 
}
