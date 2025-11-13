output "kafka_bootstrap_brokers" {
  description = "SASL/IAM bootstrap brokers for the dev Kafka cluster."
  value       = module.kafka.bootstrap_brokers_sasl_iam
}

output "schema_registry_arn" {
  description = "ARN of the dev schema registry."
  value       = module.schema_registry.registry_arn
}

output "grafana_workspace_id" {
  description = "Grafana workspace ID for dev."
  value       = module.observability.grafana_workspace_id
}

output "vercel_projects" {
  description = "Managed Vercel project IDs."
  value       = { for name, mod in module.vercel_project : name => mod.project_id }
}

output "render_services" {
  description = "Render service dashboard URLs."
  value       = { for name, mod in module.render_service : name => mod.dashboard_url }
}

output "supabase_service_user" {
  description = "Supabase service role user provisioned for this environment."
  value       = length(module.supabase) > 0 ? module.supabase[0].service_user : null
}
