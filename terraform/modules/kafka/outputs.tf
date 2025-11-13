output "bootstrap_brokers_sasl_iam" {
  description = "TLS bootstrap brokers using SASL/IAM authentication."
  value       = aws_msk_cluster.this.bootstrap_brokers_sasl_iam
}

output "zookeeper_connect_string" {
  description = "MSK managed ZooKeeper connection string."
  value       = aws_msk_cluster.this.zookeeper_connect_string
}

output "cluster_arn" {
  description = "ARN of the MSK cluster."
  value       = aws_msk_cluster.this.arn
}

output "security_group_id" {
  description = "Security group attached to the MSK brokers."
  value       = aws_security_group.kafka.id
}
