output "service_user" {
  description = "Service role user created in Supabase."
  value       = supabase_database_user.service.name
}
