variable "resource_group_name" {
  description = "Resource group where MySQL Flexible Server will be deployed"
  type        = string
}

variable "location" {
  description = "Azure region for MySQL Flexible Server"
  type        = string
}

variable "env_prefix" {
  description = "Environment prefix used for naming"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs map from vnet module (must contain key 'mysql-subnet')"
  type        = map(string)
}

variable "server_name" {
  description = "MySQL Flexible Server name (without env prefix)"
  type        = string
}

variable "admin_user" {
  description = "Administrator username for MySQL Flexible Server"
  type        = string
  default     = "mysqladmin"
}

variable "admin_password" {
  description = "Administrator password for MySQL Flexible Server"
  type        = string
  sensitive   = true
}

variable "sku_name" {
  description = "The SKU name for MySQL Flexible Server (e.g., Standard_D2ds_v4)"
  type        = string
  default     = "Standard_D2ds_v4"
}

variable "storage_size" {
  description = "Storage size in GB"
  type        = number
  default     = 128
}

variable "backup_retention_days" {
  description = "Backup retention days (7-35)"
  type        = number
  default     = 7
}

variable "availability_mode" {
  description = "High availability mode: Disabled, ZoneRedundant, SameZone"
  type        = string
  default     = "ZoneRedundant"
}

variable "mysql_version" {
  description = "MySQL version"
  type        = string
  default     = "8.0"
}

variable "zone" {
  description = "Azure availability zone"
  type        = string
  default     = "1"
}

variable "database_name" {
  description = "Default database name to create"
  type        = string
  default     = "appdb"
}

variable "tags" {
  description = "Tags to apply to MySQL resources"
  type        = map(string)
  default     = {}
}