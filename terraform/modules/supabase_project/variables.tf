variable "project_id" {
  description = "Supabase project reference ID."
  type        = string
}

variable "database_password" {
  description = "Password for the Supabase database role created by this module."
  type        = string
  sensitive   = true
}

variable "sql" {
  description = "Optional SQL statements to run after provisioning (e.g., grants)."
  type        = list(string)
  default     = []
}
