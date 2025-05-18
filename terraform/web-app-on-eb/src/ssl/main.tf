locals {
  productName = ""
  tags = merge(var.common_tags, {
    "product:Environment" = "${terraform.workspace}"
  })
}

data "terraform_remote_state" "product_infra" {
  backend = "s3"
  config = {
    bucket = var.remote-state-backend-bucket-name
    key    = "env:/${terraform.workspace}/terraform/${local.productName}/terraform.tfstate"
  }
}

data "aws_route53_zone" "dns_zone" {
  name         = var.domain_name
  private_zone = false
}

resource "aws_acm_certificate" "client_ssl_certificate" {
  domain_name       = var.client_domain_name
  validation_method = "DNS"

  tags = local.tags
}

resource "aws_acm_certificate" "server_ssl_certificate" {
  domain_name       = var.server_domain_name
  validation_method = "DNS"

  tags = local.tags
}

resource "aws_route53_record" "client_dns_record" {
  for_each = {
    for dvo in aws_acm_certificate.client_ssl_certificate.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = false
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.dns_zone.zone_id
}

resource "aws_route53_record" "server_dns_record" {
  for_each = {
    for dvo in aws_acm_certificate.server_ssl_certificate.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = false
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.dns_zone.zone_id
}

resource "aws_lb_listener" "back_end" {
  load_balancer_arn = data.terraform_remote_state.product_infra.outputs.alb-arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.server_ssl_certificate.arn
  depends_on        = [aws_route53_record.server_dns_record]

  default_action {
    type             = "forward"
    target_group_arn = data.terraform_remote_state.product_infra.outputs.tg-arn
  }
}