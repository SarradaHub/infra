terraform {
  required_providers {
    supabase = {
      source  = "supabasehq/supabase"
      version = ">= 0.11.0"
    }
  }
}

resource "supabase_database_user" "service" {
  project_ref = var.project_id
  password    = var.database_password
  name        = "platform_service"
  database    = "postgres"
  role        = "service_role"
}

resource "supabase_query" "post_create" {
  for_each    = toset(var.sql)
  project_ref = var.project_id
  query       = each.value
}
