locals {
  create_new_acr = var.existing_acr_name == "" ? true : false
  acr_name = local.create_new_acr ? "${replace(var.env_prefix, "-", "")}${replace(random_pet.rg.id, "-", "")}acr" : var.existing_acr_name
  acr_resource_group = coalesce(var.existing_acr_resource_group, var.acr_resource_group_name)
}

# Data source for existing ACR
data "azurerm_container_registry" "existing" {
  count               = local.create_new_acr ? 0 : 1
  name                = var.existing_acr_name
  resource_group_name = local.acr_resource_group
}

# Create a new ACR only if existing_acr_name is not provided
resource "azurerm_container_registry" "default" {
  count               = local.create_new_acr ? 1 : 0
  name                = local.acr_name
  resource_group_name = var.acr_resource_group_name
  location            = var.location
  sku                 = "Standard"
  admin_enabled       = false
}

# Get the ACR ID from either the existing or new ACR
locals {
  acr_id = local.create_new_acr ? azurerm_container_registry.default[0].id : data.azurerm_container_registry.existing[0].id
}