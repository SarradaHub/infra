output "project_id" {
  description = "ID of the Vercel project."
  value       = vercel_project.this.id
}

output "project_name" {
  description = "Name of the Vercel project."
  value       = vercel_project.this.name
}
