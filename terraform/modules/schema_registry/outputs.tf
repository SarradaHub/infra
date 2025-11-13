output "registry_arn" {
  description = "ARN of the Glue Schema Registry."
  value       = aws_glue_registry.this.arn
}

output "schema_arns" {
  description = "Map of schema ARNs keyed by schema name."
  value       = { for name, schema in aws_glue_schema.this : name => schema.arn }
}
