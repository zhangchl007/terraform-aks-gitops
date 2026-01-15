output "cosmosdb_account_id" {
  description = "Cosmos DB Account ID"
  value       = azurerm_cosmosdb_account.cosmos.id
}

output "cosmosdb_account_name" {
  description = "Cosmos DB Account name"
  value       = azurerm_cosmosdb_account.cosmos.name
}

output "cosmosdb_endpoint" {
  description = "Cosmos DB endpoint"
  value       = azurerm_cosmosdb_account.cosmos.endpoint
}

output "database_name" {
  description = "Cosmos DB database name"
  value       = azurerm_cosmosdb_sql_database.appdb.name
}

output "container_name" {
  description = "Cosmos DB container name"
  value       = azurerm_cosmosdb_sql_container.items.name
}

output "private_endpoint_id" {
  description = "Private endpoint ID"
  value       = azurerm_private_endpoint.cosmos.id
}