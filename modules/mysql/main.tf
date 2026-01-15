resource "random_pet" "mysql" {
  length = 1
  prefix = var.env_prefix
}

locals {
  mysql_server_name = lower(replace("${var.env_prefix}-${var.server_name}", "_", "-"))
  # Use mysql-subnet for server delegation, privateendpoint-subnet for PE (no delegation)
  mysql_subnet_key           = contains(keys(var.subnet_ids), "mysql-subnet") ? "mysql-subnet" : "node-subnet"
  privateendpoint_subnet_key = contains(keys(var.subnet_ids), "privateendpoint-subnet") ? "privateendpoint-subnet" : "node-subnet"
  tags = merge(
    {
      Environment = var.env_prefix
      ManagedBy   = "Terraform"
      Component   = "mysql-flexible-server"
    },
    var.tags
  )
}

# Private DNS zone for MySQL Flexible Server
resource "azurerm_private_dns_zone" "mysql" {
  name                = "privatelink.mysql.database.azure.com"
  resource_group_name = var.resource_group_name
  tags                = local.tags
}

# Extract VNET ID from any subnet
locals {
  vnet_id = regex("^(.+)/subnets/.+$", var.subnet_ids[local.mysql_subnet_key])[0]
}

# Virtual network link
resource "azurerm_private_dns_zone_virtual_network_link" "mysql" {
  name                  = "${random_pet.mysql.id}-mysql-dns-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.mysql.name
  virtual_network_id    = local.vnet_id
  registration_enabled  = false
}

# MySQL Flexible Server (uses delegated mysql-subnet)
resource "azurerm_mysql_flexible_server" "mysql" {
  name                   = local.mysql_server_name
  resource_group_name    = var.resource_group_name
  location               = var.location
  version                = var.mysql_version
  administrator_login    = var.admin_user
  administrator_password = var.admin_password

  sku_name = var.sku_name
  zone     = var.zone

  storage {
    size_gb = var.storage_size
  }

  backup_retention_days        = var.backup_retention_days
  geo_redundant_backup_enabled = false

  high_availability {
    mode = var.availability_mode
  }

  lifecycle {
    prevent_destroy = true
    ignore_changes  = [tags["CreatedDate"]]
  }

  delegated_subnet_id = var.subnet_ids[local.mysql_subnet_key]
  private_dns_zone_id = azurerm_private_dns_zone.mysql.id

  tags = local.tags
}

# Default database for applications
resource "azurerm_mysql_flexible_database" "appdb" {
  name                = var.database_name
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_flexible_server.mysql.name
  charset             = "utf8mb4"
  collation           = "utf8mb4_unicode_ci"
}

# Private endpoint (uses non-delegated privateendpoint-subnet)
resource "azurerm_private_endpoint" "mysql" {
  name                = "${local.mysql_server_name}-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_ids[local.privateendpoint_subnet_key]

  private_service_connection {
    name                           = "${local.mysql_server_name}-psc"
    private_connection_resource_id = azurerm_mysql_flexible_server.mysql.id
    subresource_names              = ["mysqlServer"]
    is_manual_connection           = false
  }
}
