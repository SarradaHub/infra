variable "name" {
  description = "Name of the Render service."
  type        = string
}

variable "service_type" {
  description = "Render service type (web_service, background_worker, cron_job)."
  type        = string
  default     = "web_service"
}

variable "repo" {
  description = "Git repository connected to the service."
  type = object({
    owner = string
    name  = string
    branch = string
  })
}

variable "env_vars" {
  description = "Environment variables for the Render service."
  type = map(string)
  default = {}
}

variable "plan" {
  description = "Render plan (e.g., starter, standard)."
  type        = string
  default     = "starter"
}

variable "region" {
  description = "Render region (oregon, frankfurt, singapore)."
  type        = string
  default     = "oregon"
}

variable "runtime" {
  description = "Runtime configuration (e.g., node)."
  type        = string
  default     = "node"
}

variable "build_command" {
  description = "Build command executed by Render."
  type        = string
  default     = "npm install && npm run build"
}

variable "start_command" {
  description = "Start command executed by Render."
  type        = string
  default     = "npm run start"
}
