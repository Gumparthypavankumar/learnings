output "vpc_id" {
  description = "The VPC created"
  value       = aws_vpc.vpc.id
}