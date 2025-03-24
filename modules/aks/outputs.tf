
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

# Add these outputs to your outputs.tf file
output "acr_name" {
  value = local.acr_name
}

output "acr_id" {
  value = local.acr_id
}

output "acr_login_server" {
  value = local.create_new_acr ? azurerm_container_registry.default[0].login_server : data.azurerm_container_registry.existing[0].login_server
}

output "cluster_id" {
  description = "The AKS cluster ID"
  value       = azurerm_kubernetes_cluster.k8s.id
}