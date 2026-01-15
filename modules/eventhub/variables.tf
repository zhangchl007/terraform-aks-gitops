variable "resource_group_name" {
  description = "Resource group for Event Hub resources"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "env_prefix" {
  description = "Environment prefix used for naming"
  type        = string
}

variable "namespace_name" {
  description = "Base name for the Event Hubs namespace (env prefix will be prepended)"
  type        = string
  default     = "ehns"
}

variable "eventhub_name" {
  description = "Event Hub name"
  type        = string
  default     = "events"
}

variable "sku_name" {
  description = "Event Hubs namespace SKU"
  type        = string
  default     = "Standard"
}

variable "capacity" {
  description = "Throughput Units / Capacity for the Event Hubs namespace"
  type        = number
  default     = 1
}

variable "message_retention" {
  description = "Message retention in days for the Event Hub"
  type        = number
  default     = 1
}

variable "partition_count" {
  description = "Number of partitions for the Event Hub"
  type        = number
  default     = 2
}

variable "enable_private_endpoint" {
  description = "Whether to create a private endpoint using the mysql-subnet"
  type        = bool
  default     = true
}

variable "subnet_ids" {
  description = "Subnet IDs map from the vnet module (must contain key 'mysql-subnet' when private endpoint is enabled)"
  type        = map(string)
}

variable "tags" {
  description = "Tags to apply to Event Hub resources"
  type        = map(string)
  default     = {}
}