
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
variable "kubeconfig_path" {
  description = "Path to the kubeconfig file for the AKS cluster"
  type        = string
}