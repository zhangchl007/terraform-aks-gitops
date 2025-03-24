variable resource_group_name {
  description = "Resource Group name"
  type        = string
}

variable location {
  description = "Location in which to deploy the network"
  type        = string
}

variable "env_prefix" {
  type        = string
  description = "DNS Prefix"
  default     = "tf"
}

variable "ingress_repository" {
  description = "The repository of the ingress controller"
  type        = string
  default     = "https://kubernetes.github.io/ingress-nginx"
  
}

variable "ingress_chart" {
  description = "The chart of the ingress controller"
  type        = string
  default     = "ingress-nginx"
  
}

variable "ingress_version" {
  description = "The version of the ingress controller"
  type        = string
  default     = "4.0.18"
}
variable "ingress_namespace" {
  description = "The namespace for the ingress controller"
  type        = string
  default     = "ingress-nginx"
}