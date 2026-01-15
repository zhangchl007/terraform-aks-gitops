terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

resource "random_pet" "eventhub" {
  length = 1
  prefix = var.env_prefix
}

locals {
  namespace_name             = lower(replace("${var.env_prefix}-${var.namespace_name}", "_", "-"))
  eventhub_name              = lower(var.eventhub_name)
  privateendpoint_subnet_key = contains(keys(var.subnet_ids), "privateendpoint-subnet") ? "privateendpoint-subnet" : "node-subnet"
  tags = merge(
    {
      Environment = var.env_prefix
      ManagedBy   = "Terraform"
      Component   = "eventhub"
    },
    var.tags
  )
}

# Private DNS zone for Event Hub
resource "azurerm_private_dns_zone" "eventhub" {
  name                = "privatelink.servicebus.windows.net"
  resource_group_name = var.resource_group_name
  tags                = local.tags
}

# Extract VNET ID
locals {
  vnet_id = regex("^(.+)/subnets/.+$", var.subnet_ids["node-subnet"])[0]
}

# Virtual network link between VNET and private DNS zone
resource "azurerm_private_dns_zone_virtual_network_link" "eventhub" {
  name                  = "${random_pet.eventhub.id}-eh-dns-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.eventhub.name
  virtual_network_id    = local.vnet_id
  registration_enabled  = false
}

# Event Hub Namespace
resource "azurerm_eventhub_namespace" "eventhub" {
  name                = local.namespace_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku_name
  capacity            = var.capacity

  tags = local.tags
}

# Event Hub
resource "azurerm_eventhub" "events" {
  name                = local.eventhub_name
  namespace_name      = azurerm_eventhub_namespace.eventhub.name
  resource_group_name = var.resource_group_name
  partition_count     = var.partition_count
  message_retention   = var.message_retention
}

# Private endpoint for Event Hub (uses non-delegated privateendpoint-subnet)
resource "azurerm_private_endpoint" "eventhub" {
  name                = "${local.namespace_name}-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_ids[local.privateendpoint_subnet_key]

  private_service_connection {
    name                           = "${local.namespace_name}-psc"
    private_connection_resource_id = azurerm_eventhub_namespace.eventhub.id
    subresource_names              = ["namespace"]
    is_manual_connection           = false
  }
}