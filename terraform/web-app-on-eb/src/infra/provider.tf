locals {
  productName = ""
}

terraform {
  backend "s3" {
    bucket       = var.remote-state-backend-bucket-name
    key          = "terraform/${local.productName}/terraform.tfstate"
    use_lockfile = true
    encrypt      = true
  }
}

provider "aws" {

}