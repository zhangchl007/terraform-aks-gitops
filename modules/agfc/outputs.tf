output "alb_id" {
  value = azurerm_application_load_balancer.alb.id
}

output "alb_subnet_association_id" {
  value = azurerm_application_load_balancer_subnet_association.alb.id
}

output "alb_frontend_name" {
  value = azurerm_application_load_balancer_frontend.alb.name
}
