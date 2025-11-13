variable "registry_name" {
  description = "Name of the Glue Schema Registry."
  type        = string
}

variable "description" {
  description = "Description for the registry."
  type        = string
  default     = "Platform event schema registry"
}

variable "compatibility" {
  description = "Compatibility mode (NONE, DISABLED, BACKWARD, FORWARD, FULL)."
  type        = string
  default     = "BACKWARD"
}

variable "schemas" {
  description = "Map of schema definitions keyed by name with schema definition and data format."
  type = map(object({
    description   = optional(string, "")
    data_format   = optional(string, "JSON")
    compatibility = optional(string)
    schema_def    = string
  }))
  default = {}
}

variable "tags" {
  description = "Resource tags."
  type        = map(string)
  default     = {}
}
