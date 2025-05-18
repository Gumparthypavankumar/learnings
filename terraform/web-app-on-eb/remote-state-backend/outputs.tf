output "bucket_arn" {
  value       = try(aws_s3_bucket.iac-state-backend.arn, null)
  description = "The ARN of S3 Bucket that stores terraform state"
}