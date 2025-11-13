output "vpc_id" {
  description = "ID of the platform VPC."
  value       = aws_vpc.this.id
}

output "private_subnet_ids" {
  description = "List of private subnet IDs."
  value       = [for subnet in aws_subnet.private : subnet.id]
}

output "public_subnet_ids" {
  description = "List of public subnet IDs."
  value       = [for subnet in aws_subnet.public : subnet.id]
}

output "shared_security_group_ids" {
  description = "Shared security group IDs for attaching to services."
  value       = [aws_security_group.shared.id]
}
