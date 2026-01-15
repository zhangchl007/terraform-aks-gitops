terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

resource "random_pet" "cosmos" {
  length = 1
  prefix = var.env_prefix
}

locals {
  cosmos_account_name        = lower(replace("${var.env_prefix}-${var.account_name}", "_", "-"))
  privateendpoint_subnet_key = contains(keys(var.subnet_ids), "privateendpoint-subnet") ? "privateendpoint-subnet" : "node-subnet"
  tags = merge(
    {
      Environment = var.env_prefix
      ManagedBy   = "Terraform"
      Component   = "cosmosdb"
    },
    var.tags
  )
}

# Private DNS zone for Cosmos DB
resource "azurerm_private_dns_zone" "cosmos" {
  name                = "privatelink.documents.azure.com"
  resource_group_name = var.resource_group_name
  tags                = local.tags
}

# Extract VNET ID
locals {
  vnet_id = regex("^(.+)/subnets/.+$", var.subnet_ids["node-subnet"])[0]
}

# Virtual network link between VNET and private DNS zone
resource "azurerm_private_dns_zone_virtual_network_link" "cosmos" {
  name                  = "${random_pet.cosmos.id}-cosmos-dns-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.cosmos.name
  virtual_network_id    = local.vnet_id
  registration_enabled  = false
}

# Cosmos DB Account
resource "azurerm_cosmosdb_account" "cosmos" {
  name                = local.cosmos_account_name
  location            = var.location
  resource_group_name = var.resource_group_name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"

  consistency_policy {
    consistency_level       = "Session"
    max_interval_in_seconds = 5
    max_staleness_prefix    = 100
  }

  geo_location {
    location          = var.location
    failover_priority = 0
  }

  tags = local.tags
}

# Cosmos DB Database
resource "azurerm_cosmosdb_sql_database" "appdb" {
  name                = var.database_name
  resource_group_name = var.resource_group_name
  account_name        = azurerm_cosmosdb_account.cosmos.name
}

# Cosmos DB Container
resource "azurerm_cosmosdb_sql_container" "items" {
  name                = var.container_name
  resource_group_name = var.resource_group_name
  account_name        = azurerm_cosmosdb_account.cosmos.name
  database_name       = azurerm_cosmosdb_sql_database.appdb.name
  partition_key_paths = ["/id"]
  throughput          = var.throughput
}

# Private endpoint for Cosmos DB (uses non-delegated privateendpoint-subnet)
resource "azurerm_private_endpoint" "cosmos" {
  name                = "${local.cosmos_account_name}-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_ids[local.privateendpoint_subnet_key]

  private_service_connection {
    name                           = "${local.cosmos_account_name}-psc"
    private_connection_resource_id = azurerm_cosmosdb_account.cosmos.id
    subresource_names              = ["Sql"]
    is_manual_connection           = false
  }
}