variable "location" {
  description = "The resource group location"
  type        = string
}

variable "kube_version_prefix" {
  description = "AKS Kubernetes version prefix. Formatted '[Major].[Minor]' like '1.18'. Patch version part (as in '[Major].[Minor].[Patch]') will be set to latest automatically."
  type        = string
}

variable "kube_resource_group_name" {
  description = "The resource group name to be created"
  default     = "rg-aks-tfdemo"
  type        = string
}

variable "acr_resource_group_name" {
  description = "The resource group name to be created"
  default     = "rg-aks-tfdemo"
  type        = string
}

variable "nodepool_nodes_count" {
  description = "Default nodepool nodes count"
  type       = number
}

variable "nodepool_vm_size" {
  description = "Default nodepool VM size"
  type      = string
}

variable "network_dns_service_ip" {
  description = "CNI DNS service IP"
  type        = string
}

variable "network_service_cidr" {
  description = "CNI service cidr"
  type        = string
}

variable "username" {
  description = "The username for the AKS cluster"
  type        = string

}

variable "ssh_public_key" {
  type   = string
}

variable "cluster_name" {
  type        = string
  description = "AKS Cluster Name"
}

variable "env_prefix" {
  type        = string
  description = "env Prefix"
}
variable "subnet_ids" {
  type        = map(string)
  description = "Subnet IDs"
}

variable "subnet_names" {
  type        = map(string)
  description = "Subnet Names"
}

# Add these variables to your variables.tf file if not done in step 1
variable "existing_acr_name" {
  description = "Name of the existing Azure Container Registry"
  type        = string
  default     = ""  # Empty string means create a new ACR
}

variable "existing_acr_resource_group" {
  description = "Resource group of the existing Azure Container Registry"
  type        = string
  default     = ""  # If not provided, use the AKS resource group
}


