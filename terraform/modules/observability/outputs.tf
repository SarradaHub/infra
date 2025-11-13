output "prometheus_workspace_arn" {
  description = "ARN of the Amazon Managed Prometheus workspace."
  value       = aws_prometheus_workspace.this.arn
}

output "grafana_workspace_id" {
  description = "ID of the Amazon Managed Grafana workspace."
  value       = aws_grafana_workspace.this.id
}

output "otlp_role_arn" {
  description = "IAM role ARN for the OpenTelemetry collector instances."
  value       = aws_iam_role.otlp_collector.arn
}

output "log_group_arns" {
  description = "Map of CloudWatch log group ARNs."
  value       = { for name, lg in aws_cloudwatch_log_group.shared : name => lg.arn }
}

output "alarm_names" {
  description = "List of CloudWatch alarms managed by this module."
  value       = [for alarm in aws_cloudwatch_metric_alarm.managed : alarm.alarm_name]
}
