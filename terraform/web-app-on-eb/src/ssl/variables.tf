variable "common_tags" {
  type        = map(string)
  description = "The tags to be associated with IAC provisioned resources"
  default = {
    "product:costCenter" = "<Product-Name>"
    "product:owner"      = "<Product-Name>"
    "product:role"       = "Web"
  }
}

variable "remote-state-backend-bucket-name" {
  type        = string
  description = "The name of bucket that stores terraform state of provisioned resources"
}

variable "domain_name" {
  type        = string
  nullable    = false
  description = "Domain Name"
}

variable "client_domain_name" {
  type        = string
  nullable    = false
  description = "Client Domain Name"
}

variable "server_domain_name" {
  type        = string
  nullable    = false
  description = "Server Domain Name"
}