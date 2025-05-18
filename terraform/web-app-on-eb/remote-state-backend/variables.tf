variable "common_tags" {
  type        = map(string)
  description = "The tags to be associated with IAC provisioned resources"
  default = {
    "product:environment"   = ""
    "product:contact"       = ""
    "product:provisionedOn" = ""
    "product:service"       = ""
  }
}

variable "remote-state-backend-bucket-name" {
  type        = string
  description = "The name of bucket that will store terraform states"
}