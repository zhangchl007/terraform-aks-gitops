variable "location" {
  description = "The resource group location"
  default     = "West US 2"
}

variable "kube_vnet_name" {
  description = "AKS VNET name"
  default     = "aks-kubevnet"
}

variable "kube_version_prefix" {
  description = "AKS Kubernetes version prefix. Formatted '[Major].[Minor]' like '1.18'. Patch version part (as in '[Major].[Minor].[Patch]') will be set to latest automatically."
  default     = "1.28"
}

variable "kube_resource_group_name" {
  description = "The resource group name to be created"
  default     = "rg-aks-tfdemo"
}

variable "nodepool_nodes_count" {
  description = "Default nodepool nodes count"
  default     = 2
}

variable "nodepool_vm_size" {
  description = "Default nodepool VM size"
  default     = "Standard_D4_v3"
}

variable "network_dns_service_ip" {
  description = "CNI DNS service IP"
  default     = "178.51.0.10"
}

variable "network_service_cidr" {
  description = "CNI service cidr"
  default     = "178.51.0.0/16"
}

variable "address_space" {
  description = "Vnet address_space"
  type = list(string)

  default = [ "10.4.0.0/22" ]

}

variable "username" {
  description = "The username for the AKS cluster"
  default     = "azureuser"

}

variable "ssh_public_key" {
  default = "~/.ssh/id_rsa.pub"
}

variable "cluster_name" {
  type        = string
  description = "AKS Cluster Name"
  default     = "private-aks"
}

variable "env_prefix" {
  type        = string
  description = "DNS Prefix"
  default     = "tf"
}
variable "subnets" {
  description = "The list of subnets to be created"
  type = list(object({
    name             = string
    address_prefixes = list(string)
    delegation       = string
  }))

  default = [
    {
      name : "node-subnet"
      address_prefixes : ["10.4.0.0/24"]
      delegation       = ""
    },
    {
      name : "pod-subnet"
      address_prefixes : ["10.4.1.0/24"]
      delegation       = "Microsoft.ContainerService/managedClusters"
    },
    {
      name : "appgw-subnet"
      address_prefixes : ["10.4.2.0/24"]
      delegation       = ""
    },

    {
      name : "ingress-subnet"
      address_prefixes : ["10.4.3.0/24"]
      delegation       = "Microsoft.ServiceNetworking/trafficControllers"
    }
  ]
}

variable "acr_name" {
  description = "Name of the existing Azure Container Registry"
  type        = string
  default     = ""  # Empty string means create a new ACR
}

variable "acr_resource_group" {
  description = "Resource group of the existing Azure Container Registry"
  type        = string
  default     = ""  # If not provided, use the AKS resource group
}

variable "argocd_name" {
  description = "The name of the ArgoCD release."
  type        = string
  default     = "argocd"
}
variable "argocd_namespace" {
  description = "The namespace where ArgoCD will be installed."
  type        = string
  default     = "argocd"
}
variable "argocd_repository" {
  description = "The Helm repository for ArgoCD."
  type        = string
  default     = "https://argoproj.github.io/argo-helm"
}
variable "argocd_chart" {
  description = "The Helm chart for ArgoCD."
  type        = string
  default     = "argo-cd"
}
variable "argocd_version" {
  description = "The version of the ArgoCD Helm chart."
  type        = string
  default     = "5.24.1"
}
