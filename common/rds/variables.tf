##################
#RDS Parameters
##################
variable "vpcid" {}

variable "vpc_name" {
  description = "Name of the VPC"
  default     = "unknown"
}

variable "datalayer_subnet_ids" {
  description = "Name of the datalayer_subnet_id"
  type        = "list"
}

variable "datalayer_security_groups" {
  description = "Name of the datalayer_security_groups"
  type        = "list"
}

variable "secgroup2" {
  type        = "list"
  description = "Private Zone to RDS"
}

variable "sg02" {
  type        = "list"
  description = "Informatica to RDS"
}

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
