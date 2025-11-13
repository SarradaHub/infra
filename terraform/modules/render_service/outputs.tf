output "service_id" {
  description = "ID of the Render service."
  value       = render_service.this.id
}

output "dashboard_url" {
  description = "Render dashboard URL for the service."
  value       = render_service.this.dashboard_url
}
