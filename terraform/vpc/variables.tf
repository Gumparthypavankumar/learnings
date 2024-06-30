variable "aws_region" {
  description = "The region to provision resources"
  type        = string
  default     = "us-east-1"
}

variable "organization" {
  description = "The organization the resources should be provisioned for"
  type        = string
  default     = "test"
}

variable "required_tags" {
  description = "The required tags for any resource provisioned via IAC"
  type        = map(string)
}

variable "vpc_cidr" {
  description = "The CIDR of VPC"
  type        = string
  default     = "10.2.0.0/16"
}

variable "availability_zones" {
  description = "The availablity zones for active region"
  type = set(string)
  default = [ "us-east-1a", "us-east-1b", "us-east-1c" ]
}

variable "public_subnet_cidrs" {
  description = "The public subnets cidrs"
  type        = set(string)
  default = [
    "10.2.0.0/25",
    "10.2.0.128/25",
    "10.2.1.0/25"
  ]
}

variable "private_subnet_cidrs" {
  description = "The private subnets cidrs"
  type        = set(string)
  default = [
    "10.2.1.128/25",
    "10.2.2.0/25",
    "10.2.2.128/25",
  ]
}

variable "persistence_subnet_cidrs" {
  description = "The persistence subnet cidrs"
  type        = set(string)
  default = [
    "10.2.3.0/25",
    "10.2.3.128/26",
    "10.2.3.192/26"
  ]
}