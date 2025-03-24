locals {
  appgw_name = "${replace(var.env_prefix, "-", "")}${replace(random_pet.rg.id)}appgw"
}

resource "azurerm_application_load_balancer" "alb" {
  name                = local.appgw_name
  location            = var.location
  resource_group_name = var.resource_group_name

}
 
resource "azurerm_application_load_balancer_subnet_association" "alb" {
  name                         = "alb-subnet-association"
  application_load_balancer_id = azurerm_application_load_balancer.alb.id
  subnet_id                    = azurerm_subnet.appgw_subnet.id
}
 
resource "azurerm_application_load_balancer_frontend" "alb" {
  name                         = "alb-frontend"
  application_load_balancer_id = azurerm_application_load_balancer.alb.id
}