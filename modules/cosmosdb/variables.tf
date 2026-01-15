variable "resource_group_name" {
  description = "Resource group for Cosmos DB"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "env_prefix" {
  description = "Environment prefix for naming"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs map from vnet module"
  type        = map(string)
}

variable "account_name" {
  description = "Cosmos DB account name (without env prefix)"
  type        = string
  default     = "cosmos"
}

variable "database_name" {
  description = "Cosmos DB database name"
  type        = string
  default     = "appdb"
}

variable "container_name" {
  description = "Cosmos DB container name"
  type        = string
  default     = "items"
}

variable "throughput" {
  description = "Cosmos DB manual throughput (RU/s)"
  type        = number
  default     = 400
}

variable "tags" {
  description = "Tags to apply to Cosmos DB resources"
  type        = map(string)
  default     = {}
}