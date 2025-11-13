variable "aws_region" {
  description = "AWS region for staging."
  type        = string
  default     = "us-east-2"
}

variable "vpc_cidr" {
  description = "CIDR block for staging VPC."
  type        = string
  default     = "10.20.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDRs."
  type        = list(string)
  default     = [
    "10.20.0.0/24",
    "10.20.1.0/24",
    "10.20.2.0/24"
  ]
}

variable "private_subnet_cidrs" {
  description = "Private subnet CIDRs."
  type        = list(string)
  default     = [
    "10.20.10.0/24",
    "10.20.11.0/24",
    "10.20.12.0/24"
  ]
}

variable "extra_tags" {
  description = "Extra resource tags."
  type        = map(string)
  default     = {}
}

variable "vercel_team_id" {
  description = "Optional Vercel team ID for staging deployments."
  type        = string
  default     = null
}

variable "vercel_projects" {
  description = "Vercel projects managed in staging."
  type = map(object({
    framework      = string
    git_repository = object({ type = string; repo = string })
    env_variables  = map(object({ value = string; target = list(string); type = optional(string, "encrypted") }))
    domains        = list(string)
  }))
  default = {}
}

variable "render_services" {
  description = "Render services defined for staging."
  type = map(object({
    service_type  = string
    repo          = object({ owner = string, name = string, branch = string })
    env_vars      = map(string)
    plan          = optional(string, "starter")
    region        = optional(string, "oregon")
    runtime       = optional(string, "node")
    build_command = optional(string, "npm install && npm run build")
    start_command = optional(string, "npm run start")
  }))
  default = {}
}

variable "supabase" {
  description = "Supabase configuration for staging."
  type = object({
    project_id        = string
    database_password = string
    sql               = optional(list(string), [])
  })
  default = null
}
