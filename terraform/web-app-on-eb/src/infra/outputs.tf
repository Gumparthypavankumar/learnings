output "vpc-id" {
  description = "The ID of the VPC"
  value       = try(module.vpc.vpc_id, null)
}

output "alb-arn" {
  description = "The ARN of ALB"
  value       = try(module.eb_environment.load_balancers[0], null)
}

output "db-endpoint" {
  description = "The DB endpoint"
  value       = try(module.database.db_instance_endpoint, null)
}

output "s3-static-site" {
  description = "The Bucket name of S3 Client App"
  value       = try(aws_s3_bucket.s3-static-site.bucket, null)
}

output "s3-object-store" {
  description = "The Bucket name of S3 Object Store"
  value       = try(aws_s3_bucket.s3-object-store.bucket, null)
}

output "cloudfront-distribution-id" {
  description = "The Distribution ID of Cloudfront"
  value       = try(module.cdn.cloudfront_distribution_id, null)
}

