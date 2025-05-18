locals {
  productName = ""
  tags = {
    "productName:costCenter"  = local.productName
    "productName:owner"       = local.productName
    "productName:role"        = "Web"
    "productName:Environment" = terraform.workspace
  }
}

# ------------------------------------------
# Network Config
# ------------------------------------------
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = var.vpc-name
  cidr = var.cidr-address
  azs  = var.vpc-availability-zones

  public_subnets  = var.public-subnets
  private_subnets = var.private-subnets

  public_subnet_names  = var.public-subnets-names
  private_subnet_names = var.private-subnets-names

  database_subnets           = var.persistence-subnets
  database_subnet_names      = var.persistence-subnets-names
  database_subnet_group_name = "${terraform.workspace}-subnet-group"

  private_dedicated_network_acl = true
  manage_default_network_acl    = false
  manage_default_route_table    = false

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  enable_dns_hostnames = true
  enable_dns_support   = true

  vpc_tags = local.tags

  tags = local.tags
}


# --------------------------------------
# Compute Config
# --------------------------------------
locals {
  is_prod = terraform.workspace == "prod" ? true : false
}

resource "aws_security_group" "eb_elb_sg" {
  name        = "eb-elb-${local.productName}-${terraform.workspace}-sg"
  tags        = local.tags
  description = "Security group of ALB in ${terraform.workspace} environment"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# --------------------------------------------
# Elastic BeanStalk
# --------------------------------------------
module "eb_application" {
  source      = "cloudposse/elastic-beanstalk-application/aws"
  name        = var.eb_application_name
  description = "${lower(local.productName)} ${terraform.workspace} Application"
}

module "eb_environment" {
  source                             = "cloudposse/elastic-beanstalk-environment/aws"
  description                        = var.eb_description
  name                               = "${var.eb_application_name}-env"
  elastic_beanstalk_application_name = var.eb_application_name

  # ---------------------------
  # Network Config
  # ---------------------------
  environment_type       = var.eb_environment_type
  loadbalancer_type      = var.eb_loadbalancer_type
  loadbalancer_crosszone = var.eb_loadbalancer_crosszone_enabled

  loadbalancer_subnets = module.vpc.public_subnets
  application_subnets  = module.vpc.private_subnets
  vpc_id               = module.vpc.vpc_id
  instance_type        = var.eb_instance_type

  managed_actions_enabled    = local.is_prod ? true : false
  enhanced_reporting_enabled = local.is_prod ? true : false

  rolling_update_enabled = local.is_prod ? true : false
  autoscale_min          = local.is_prod ? 1 : 1
  autoscale_max          = local.is_prod ? 2 : 1

  solution_stack_name         = var.eb_application_stack
  associate_public_ip_address = false
  tier                        = "WebServer"

  healthcheck_url                            = var.eb_health_check_url
  enable_loadbalancer_logs                   = false
  logs_retention_in_days                     = local.is_prod ? 30 : 7
  loadbalancer_security_groups               = [aws_security_group.eb_elb_sg.id]
  loadbalancer_managed_security_group        = aws_security_group.eb_elb_sg.id
  prefer_legacy_ssm_policy                   = false
  spot_fleet_on_demand_above_base_percentage = 0
  spot_fleet_on_demand_base                  = 0

  availability_zone_selector            = "Any"
  application_port                      = 80
  keypair                               = var.instance_key_pair_name
  root_volume_size                      = 20
  autoscale_measure_name                = "CPUUtilization"
  autoscale_statistic                   = "Maximum"
  autoscale_unit                        = "Percent"
  autoscale_lower_bound                 = 20
  autoscale_upper_bound                 = 60
  deployment_ignore_health_check        = local.is_prod ? false : true
  healthcheck_healthy_threshold_count   = 3
  healthcheck_unhealthy_threshold_count = 5
  healthcheck_httpcodes_to_match        = ["200", "404"]
  healthcheck_interval                  = 15
  healthcheck_timeout                   = 10

  region = var.aws_region
  tags   = local.tags
  env_vars = {
    SERVER_PORT = 8080
  }
}

# --------------------------------------------
# Storage
# --------------------------------------------
resource "aws_security_group" "db_sg" {
  name        = "db-${local.productName}-${terraform.workspace}-sg"
  tags        = local.tags
  description = "Security group of RDS in ${terraform.workspace} environment"
  vpc_id      = module.vpc.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "allow_eb_app" {
  security_group_id            = aws_security_group.db_sg.id
  referenced_security_group_id = module.eb_environment.security_group_id

  from_port   = 3306
  ip_protocol = "tcp"
  to_port     = 3306
}

resource "aws_vpc_security_group_egress_rule" "allow_eb_app" {
  security_group_id = aws_security_group.db_sg.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}

module "database" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 6.12"

  identifier = "db-${terraform.workspace}-${local.productName}"
  tags       = local.tags

  engine                  = "mysql"
  engine_version          = "8.0.40"
  family                  = "mysql8.0"
  instance_class          = var.db_instance_class
  allocated_storage       = var.db_provisioned_storage
  max_allocated_storage   = local.is_prod ? 1000 : null
  maintenance_window      = "Sun:00:00-Sun:01:00"
  backup_window           = "22:00-00:00"
  backup_retention_period = 7
  db_subnet_group_name    = module.vpc.database_subnet_group_name
  major_engine_version    = "8.0"
  publicly_accessible     = false

  db_name                     = var.db_initial_name
  username                    = var.db_master_user_name
  password                    = var.db_master_password # This is sensitive and logged in state file
  port                        = 3306
  manage_master_user_password = false

  iam_database_authentication_enabled = false
  vpc_security_group_ids              = [aws_security_group.db_sg.id]

  deletion_protection             = true
  parameter_group_name            = "parameters-${terraform.workspace}-${local.productName}"
  parameter_group_use_name_prefix = false
  parameter_group_description     = "Parameter group for ${local.productName} ${terraform.workspace} DB"
  option_group_name               = "options-${terraform.workspace}-${local.productName}"
  option_group_use_name_prefix    = false
  option_group_description        = "Option group for ${local.productName} ${terraform.workspace} DB"

}

# ------------------------------------------------
# Configuring the S3 Bucket For Static Site
# ------------------------------------------------

resource "random_string" "bucket_name" {
  length  = 8
  special = false
  upper   = false
  lower   = true
  numeric = true
}

resource "aws_s3_bucket" "s3-static-site" {
  bucket = "s3-${local.productName}-${terraform.workspace}-client-app-${random_string.bucket_name.result}"
}

# ------------------------------------------------
# Configuring the SSE encryption for the bucket
# ------------------------------------------------
resource "aws_s3_bucket_server_side_encryption_configuration" "s3-static-site-encryption-config" {
  bucket = aws_s3_bucket.s3-static-site.id

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
resource "aws_s3_bucket_public_access_block" "s3-static-site-access-policies" {
  bucket = aws_s3_bucket.s3-static-site.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# ------------------------------------------------
# Configuring the S3 Bucket For Object Storage
# ------------------------------------------------
resource "aws_s3_bucket" "s3-object-store" {
  bucket = "s3-${local.productName}-${terraform.workspace}-storage-${random_string.bucket_name.result}"
}

# ------------------------------------------------
# Configuring the SSE encryption for the bucket
# ------------------------------------------------
resource "aws_s3_bucket_server_side_encryption_configuration" "s3-object-store-encryption-config" {
  bucket = aws_s3_bucket.s3-object-store.id

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
resource "aws_s3_bucket_public_access_block" "s3-object-store-access-policies" {
  bucket = aws_s3_bucket.s3-object-store.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

module "cdn" {
  source  = "terraform-aws-modules/cloudfront/aws"
  version = ">= 4.1"

  aliases = []

  comment             = "Distribution for ${local.productName} Client App in ${terraform.workspace} environment"
  enabled             = true
  is_ipv6_enabled     = true
  price_class         = "PriceClass_200"
  retain_on_delete    = false
  wait_for_deployment = false
  default_root_object = "index.html"

  create_origin_access_control = true
  origin_access_control = {
    s3_oac = {
      description      = "CloudFront access to S3"
      origin_type      = "s3"
      signing_behavior = "always"
      signing_protocol = "sigv4"
    }
  }

  origin = {
    s3_oac = {
      domain_name           = aws_s3_bucket.s3-static-site.bucket_regional_domain_name
      origin_access_control = "s3_oac"
    }
  }

  default_cache_behavior = {
    target_origin_id       = "s3_oac"
    viewer_protocol_policy = local.is_prod ? "redirect-to-https" : "allow-all"

    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD"]
    compress        = true
    query_string    = false
  }

  custom_error_response = [
    {
      error_code            = 403
      response_code         = 200
      error_caching_min_ttl = 10
      response_page_path    = "/index.html"
    }
  ]

}

resource "aws_s3_bucket_policy" "allow_cdn_distribution" {
  bucket = aws_s3_bucket.s3-static-site.id
  policy = data.aws_iam_policy_document.allow_cdn_distribution.json
}

data "aws_iam_policy_document" "allow_cdn_distribution" {
  statement {
    sid = "PolicyForCloudFrontPrivateContent"
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${aws_s3_bucket.s3-static-site.arn}/*",
    ]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"

      values = [module.cdn.cloudfront_distribution_arn]
    }
  }
}