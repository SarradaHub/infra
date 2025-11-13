variable "cluster_name" {
  description = "Name for the MSK cluster."
  type        = string
}

variable "kafka_version" {
  description = "Kafka version to deploy."
  type        = string
  default     = "3.7.0"
}

variable "broker_instance_type" {
  description = "EC2 instance type for Kafka brokers."
  type        = string
  default     = "kafka.m7g.large"
}

variable "number_of_broker_nodes" {
  description = "Total number of broker nodes (must be even)."
  type        = number
  default     = 3
}

variable "subnet_ids" {
  description = "Private subnet IDs for the brokers."
  type        = list(string)
}

variable "security_group_ids" {
  description = "Additional security groups to attach to the brokers."
  type        = list(string)
  default     = []
}

variable "vpc_id" {
  description = "VPC where the cluster will be created."
  type        = string
}

variable "encryption_kms_key_arn" {
  description = "Optional KMS key ARN for data at rest encryption."
  type        = string
  default     = null
}

variable "monitoring_prometheus" {
  description = "Enable Prometheus monitoring integration."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Resource tags."
  type        = map(string)
  default     = {}
}
