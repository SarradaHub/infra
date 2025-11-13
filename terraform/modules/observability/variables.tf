variable "grafana_workspace_name" {
  description = "Name for the Amazon Managed Grafana workspace."
  type        = string
}

variable "amp_workspace_alias" {
  description = "Alias for the Amazon Managed Prometheus workspace."
  type        = string
  default     = "platform-events"
}

variable "log_group_names" {
  description = "List of CloudWatch log groups to create for shared services."
  type        = list(string)
  default     = [
    "/platform/msk",
    "/platform/event-gateway",
    "/platform/schemas"
  ]
}

variable "metric_alarms" {
  description = "Optional CloudWatch metric alarm definitions."
  type = list(object({
    name                = string
    metric_name         = string
    namespace           = string
    statistic           = string
    period              = number
    evaluation_periods  = number
    threshold           = number
    comparison_operator = string
    datapoints_to_alarm = optional(number)
    treat_missing_data  = optional(string, "missing")
    dimensions          = optional(map(string), {})
    alarm_description   = optional(string, "")
  }))
  default = []
}

variable "tags" {
  description = "Resource tags."
  type        = map(string)
  default     = {}
}
