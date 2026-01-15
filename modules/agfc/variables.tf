variable "resource_group_name" {
  description = "Resource Group name"
  type        = string
}

variable "location" {
  description = "Location in which to deploy AGFC"
  type        = string
}

variable "env_prefix" {
  description = "Environment prefix for naming"
  type        = string
}

variable "vnet_id" {
  description = "Virtual Network ID"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for AGFC deployment"
  type        = string
}

variable "agfc_name" {
  description = "Application Gateway for Containers name"
  type        = string
  default     = "agfc"
}

variable "frontend_name" {
  description = "Frontend name for AGFC"
  type        = string
  default     = "agfc-frontend"
}

variable "frontend_ip" {
  description = "Frontend IP for AGFC (must be in subnet range)"
  type        = string
}

variable "tags" {
  description = "Tags to apply to AGFC resources"
  type        = map(string)
  default     = {}
}