variable "aws_region" {
  description = "AWS region for production."
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for production VPC."
  type        = string
  default     = "10.30.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDR blocks."
  type        = list(string)
  default     = [
    "10.30.0.0/24",
    "10.30.1.0/24",
    "10.30.2.0/24"
  ]
}

variable "private_subnet_cidrs" {
  description = "Private subnet CIDR blocks."
  type        = list(string)
  default     = [
    "10.30.10.0/24",
    "10.30.11.0/24",
    "10.30.12.0/24"
  ]
}

variable "extra_tags" {
  description = "Additional resource tags."
  type        = map(string)
  default     = {}
}

variable "vercel_team_id" {
  description = "Vercel team ID for production deployments."
  type        = string
  default     = null
}

variable "vercel_projects" {
  description = "Vercel projects to manage in production."
  type = map(object({
    framework      = string
    git_repository = object({ type = string; repo = string })
    env_variables  = map(object({ value = string; target = list(string); type = optional(string, "encrypted") }))
    domains        = list(string)
  }))
  default = {}
}

variable "render_services" {
  description = "Render services for production workloads."
  type = map(object({
    service_type  = string
    repo          = object({ owner = string, name = string, branch = string })
    env_vars      = map(string)
    plan          = optional(string, "standard")
    region        = optional(string, "oregon")
    runtime       = optional(string, "node")
    build_command = optional(string, "npm install && npm run build")
    start_command = optional(string, "npm run start")
  }))
  default = {}
}

variable "supabase" {
  description = "Supabase production configuration."
  type = object({
    project_id        = string
    database_password = string
    sql               = optional(list(string), [])
  })
  default = null
}
