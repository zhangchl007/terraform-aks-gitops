locals {
  lookup_existing_acr = trimspace(var.existing_acr_name) != ""
}

data "external" "acr_lookup" {
  count = local.lookup_existing_acr ? 1 : 0
  program = [
    "bash",
    "-c",
    <<-EOT
      set -eo pipefail
      NAME="${var.existing_acr_name}"
      RG="${var.existing_acr_resource_group}"
      if [ -z "$NAME" ]; then
        echo '{"exists":"false"}'
        exit 0
      fi
      if [ -n "$RG" ]; then
        if az acr show --name "$NAME" --resource-group "$RG" >/dev/null 2>&1; then
          echo '{"exists":"true"}'
        else
          echo '{"exists":"false"}'
        fi
      else
        if az acr show --name "$NAME" >/dev/null 2>&1; then
          echo '{"exists":"true"}'
        else
          echo '{"exists":"false"}'
        fi
      fi
    EOT
  ]
}

locals {
  acr_exists         = local.lookup_existing_acr ? data.external.acr_lookup[0].result.exists == "true" : false
  generated_acr_name = var.new_acr_name != "" ? var.new_acr_name : "${replace(var.env_prefix, "-", "")}${replace(random_pet.rg.id, "-", "")}acr"
  acr_name           = local.acr_exists ? var.existing_acr_name : local.generated_acr_name
  acr_resource_group = local.acr_exists && var.existing_acr_resource_group != "" ? var.existing_acr_resource_group : azurerm_resource_group.kube.name
}

data "azurerm_container_registry" "existing" {
  count               = local.acr_exists ? 1 : 0
  name                = var.existing_acr_name
  resource_group_name = local.acr_resource_group
}

resource "azurerm_container_registry" "default" {
  count               = local.acr_exists ? 0 : 1
  name                = local.acr_name
  resource_group_name = azurerm_resource_group.kube.name
  location            = var.location
  sku                 = "Standard"
  admin_enabled       = false
}

locals {
  acr_id           = local.acr_exists ? data.azurerm_container_registry.existing[0].id : azurerm_container_registry.default[0].id
  acr_login_server = local.acr_exists ? data.azurerm_container_registry.existing[0].login_server : azurerm_container_registry.default[0].login_server
}
