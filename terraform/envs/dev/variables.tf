variable "aws_region" {
  description = "AWS region for the dev environment."
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the dev VPC."
  type        = string
  default     = "10.10.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDR blocks."
  type        = list(string)
  default     = [
    "10.10.0.0/24",
    "10.10.1.0/24",
    "10.10.2.0/24"
  ]
}

variable "private_subnet_cidrs" {
  description = "Private subnet CIDR blocks."
  type        = list(string)
  default     = [
    "10.10.10.0/24",
    "10.10.11.0/24",
    "10.10.12.0/24"
  ]
}

variable "extra_tags" {
  description = "Additional tags to apply to resources."
  type        = map(string)
  default     = {}
}

variable "vercel_team_id" {
  description = "Optional Vercel team ID for deployments."
  type        = string
  default     = null
}

variable "vercel_projects" {
  description = "Vercel projects to manage in this environment."
  type = map(object({
    framework = string
    git_repository = object({
      type = string
      repo = string
    })
    env_variables = map(object({
      value  = string
      target = list(string)
      type   = optional(string, "encrypted")
    }))
    domains = list(string)
  }))
  default = {}
}

variable "render_services" {
  description = "Render services to manage (API workloads)."
  type = map(object({
    service_type   = string
    repo           = object({ owner = string, name = string, branch = string })
    env_vars       = map(string)
    plan           = optional(string, "starter")
    region         = optional(string, "oregon")
    runtime        = optional(string, "node")
    build_command  = optional(string, "npm install && npm run build")
    start_command  = optional(string, "npm run start")
  }))
  default = {}
}

variable "supabase" {
  description = "Supabase project configuration."
  type = object({
    project_id        = string
    database_password = string
    sql               = optional(list(string), [])
  })
  default = null
}
