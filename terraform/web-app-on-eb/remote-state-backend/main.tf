# -------------------------------------------------------------------
# Create Backend State with AWS Provider and S3 for State Management
# -------------------------------------------------------------------
terraform {
  required_version = ">= 1.11.4"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# ------------------------------------------------
# Configuring Provider to interact with AWS
# ------------------------------------------------
provider "aws" {
  default_tags {
    tags = var.common_tags
  }
}

# ------------------------------------------------
# Configuring the S3 Bucket
# ------------------------------------------------
resource "aws_s3_bucket" "iac-state-backend" {
  bucket = var.remote-state-backend-bucket-name
}

# ------------------------------------------------
# Configuring the SSE encryption for the bucket
# ------------------------------------------------
resource "aws_s3_bucket_server_side_encryption_configuration" "iac-state-backend-encryption-config" {
  bucket = aws_s3_bucket.iac-state-backend.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = true
  }
}

# ------------------------------------------------
# Configuring the Bucket Access
# ------------------------------------------------
resource "aws_s3_bucket_public_access_block" "iac-state-backend-access-policies" {
  bucket = aws_s3_bucket.iac-state-backend.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# ------------------------------------------------
# Configuration for Remote State Backend
# ------------------------------------------------
terraform {
  backend "s3" {
    bucket       = var.remote-state-backend-bucket-name
    key          = "terraform/backend/terraform.tfstate"
    use_lockfile = true
    encrypt      = true
  }
}