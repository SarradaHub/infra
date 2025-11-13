variable "project_name" {
  description = "Name of the Vercel project."
  type        = string
}

variable "framework" {
  description = "Framework preset (e.g., nextjs, vite)."
  type        = string
  default     = "vite"
}

variable "git_repository" {
  description = "Git repository configuration for auto-deploys."
  type = object({
    type = string
    repo = string
  })
  default = null
}

variable "team_id" {
  description = "Optional Vercel team ID."
  type        = string
  default     = null
}

variable "env_variables" {
  description = "Map of environment variables by environment (production/staging/development)."
  type = map(object({
    value     = string
    target    = list(string) # e.g., ["production", "preview", "development"]
    type      = optional(string, "encrypted")
  }))
  default = {}
}

variable "domains" {
  description = "List of custom domains to assign."
  type        = list(string)
  default     = []
}
