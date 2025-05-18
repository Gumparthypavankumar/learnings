# --------------------------------
# State Variables
# --------------------------------
variable "remote-state-backend-bucket-name" {
  type        = string
  description = "The name of bucket that will store terraform states"
}
# --------------------------------
# Network Variables
# --------------------------------
variable "vpc-name" {
  type = string
}

variable "cidr-address" {
  type = string
}

variable "vpc-availability-zones" {
  type = list(string)
}

variable "private-subnets" {
  type = list(string)
}

variable "private-subnets-names" {
  type = list(string)
}

variable "public-subnets" {
  type = list(string)
}

variable "public-subnets-names" {
  type = list(string)
}

variable "persistence-subnets" {
  type = list(string)
}

variable "persistence-subnets-names" {
  type = list(string)
}

variable "instance_key_pair_name" {
  type        = string
  description = "Provide the key pair name which is already available in same region where the resources are provisioned"
}

# -----------------------------------
# Application Variables
# -----------------------------------
variable "eb_description" {
  type = string
}

variable "eb_application_name" {
  type = string
}

variable "eb_environment_type" {
  type = string
}

variable "eb_loadbalancer_type" {
  type = string
}

variable "eb_loadbalancer_crosszone_enabled" {
  type = bool
}

variable "eb_instance_type" {
  type = string
}

variable "eb_application_stack" {
  type    = string
  default = "64bit Amazon Linux 2023 v4.6.1 running PHP 8.2"
}

variable "eb_health_check_url" {
  type    = string
  default = "/"
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

# --------------------------------
# Storage Variables
# --------------------------------
variable "db_instance_class" {
  type    = string
  default = "db.t4g.micro"
}

variable "db_provisioned_storage" {
  type    = number
  default = 20
}

variable "db_initial_name" {
  type        = string
  description = "The initial database to create once provisioned"
  default     = "sample"
}

variable "db_master_user_name" {
  type        = string
  description = "The master username"
}

variable "db_master_password" {
  type        = string
  description = "The master password"
}
