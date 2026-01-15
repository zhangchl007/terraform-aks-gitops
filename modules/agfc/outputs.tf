output "agfc_id" {
  description = "Application Gateway for Containers ID"
  value       = azurerm_application_load_balancer.agfc.id
}

output "agfc_name" {
  description = "Application Gateway for Containers name"
  value       = azurerm_application_load_balancer.agfc.name
}

output "frontend_id" {
  description = "AGFC Frontend ID"
  value       = azurerm_application_load_balancer_frontend.agfc.id
}

output "frontend_name" {
  description = "AGFC Frontend name"
  value       = azurerm_application_load_balancer_frontend.agfc.name
}

output "subnet_association_id" {
  description = "AGFC Subnet association ID"
  value       = azurerm_application_load_balancer_subnet_association.agfc.id
}

output "private_dns_zone_id" {
  description = "Private DNS Zone ID for AGFC"
  value       = azurerm_private_dns_zone.agfc.id
}

output "private_dns_zone_name" {
  description = "Private DNS Zone name for AGFC"
  value       = azurerm_private_dns_zone.agfc.name
}
