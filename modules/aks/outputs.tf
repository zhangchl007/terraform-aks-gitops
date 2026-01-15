output "cluster_password" {
  value     = azurerm_kubernetes_cluster.k8s.kube_config[0].password
  sensitive = true
}

output "cluster_username" {
  value     = azurerm_kubernetes_cluster.k8s.kube_config[0].username
  sensitive = true
}

output "host" {
  value     = azurerm_kubernetes_cluster.k8s.kube_config[0].host
  sensitive = true
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.k8s.kube_config
}

output "kube_config_raw" {
  value = azurerm_kubernetes_cluster.k8s.kube_config_raw
}
output "acr_login_server" {
  description = "Azure Container Registry login server"
  value       = local.acr_login_server
}

output "cluster_id" {
  description = "The AKS cluster ID"
  value       = azurerm_kubernetes_cluster.k8s.id
}