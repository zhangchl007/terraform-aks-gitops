variable "resource_group_name" {
  description = "Resource group hosting the Managed Redis instance"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "redis_name" {
  description = "Azure Managed Redis name"
  type        = string
}

variable "redis_sku_name" {
  description = "Managed Redis SKU (e.g. Balanced_B0, Premium_P1)"
  type        = string
  default     = "Balanced_B0"
}

variable "redis_client_protocol" {
  description = "Client protocol (Encrypted or Plaintext)"
  type        = string
  default     = "Encrypted"
}

variable "redis_minimum_tls_version" {
  description = "Minimum TLS version"
  type        = string
  default     = "1.2"
}

variable "redis_enable_non_ssl_port" {
  description = "Enable plaintext port 6379"
  type        = bool
  default     = false
}

variable "redis_eviction_policy" {
  description = "Redis eviction policy (maxmemory-policy)"
  type        = string
  default     = "allkeys-lru"
}

variable "tags" {
  description = "Tags applied to Managed Redis"
  type        = map(string)
  default     = {}
}
variable "database_name" {
  description = "Name of the Redis database"
  type        = string
  default     = "default"
}
variable "modules" {
  description = "List of Redis modules to enable"
  type        = list(string)
  default     = ["RedisBloom", "RedisTimeSeries"]
}

variable "use_azapi" {
  type    = bool
  default = true
}
variable "env_prefix" {
  description = "Environment prefix used for naming"
  type        = string
}