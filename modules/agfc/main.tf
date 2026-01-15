terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

resource "random_pet" "agfc" {
  length = 2
  prefix = replace(var.env_prefix, "-", "")
}

locals {
  agfc_name = lower(replace("${var.env_prefix}-${var.agfc_name}", "_", "-"))
  tags = merge(
    {
      Environment = var.env_prefix
      ManagedBy   = "Terraform"
      Component   = "agfc"
      CreatedDate = formatdate("YYYY-MM-DD", timestamp())
    },
    var.tags
  )
}

# Application Gateway for Containers
resource "azurerm_application_load_balancer" "agfc" {
  name                = local.agfc_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = local.tags

  lifecycle {
    ignore_changes = [tags["CreatedDate"]]
  }
}

# Associate AGFC with the subnet
resource "azurerm_application_load_balancer_subnet_association" "agfc" {
  name                         = "${local.agfc_name}-subnet-assoc"
  application_load_balancer_id = azurerm_application_load_balancer.agfc.id
  subnet_id                    = var.subnet_id
}

# Frontend for AGFC
resource "azurerm_application_load_balancer_frontend" "agfc" {
  name                         = var.frontend_name
  application_load_balancer_id = azurerm_application_load_balancer.agfc.id
}

# Private DNS zone for AGFC
resource "azurerm_private_dns_zone" "agfc" {
  name                = "agfc.internal"
  resource_group_name = var.resource_group_name
  tags                = local.tags

  lifecycle {
    ignore_changes = [tags["CreatedDate"]]
  }
}

# Virtual network link for private DNS
resource "azurerm_private_dns_zone_virtual_network_link" "agfc" {
  name                  = "${random_pet.agfc.id}-agfc-dns-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.agfc.name
  virtual_network_id    = var.vnet_id
  registration_enabled  = false
  tags                  = local.tags

  lifecycle {
    ignore_changes = [tags["CreatedDate"]]
  }
}