output "cluster_password" {
  value     = module.aks.kube_config[0].password
  sensitive = true
}

output "cluster_username" {
  value     = module.aks.kube_config[0].username
  sensitive = true
}

output "host" {
  value     = module.aks.kube_config[0].host
  sensitive = true
}

output "kube_config" {
  value     = module.aks.kube_config_raw
  sensitive = true
}

output "object_id" {
  value = data.azurerm_client_config.current.object_id
}