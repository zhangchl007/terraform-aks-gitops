# Redis Enterprise cluster ID (first instance, since count is 1 when use_azapi = true)
output "redis_cluster_id" {
  description = "Redis Enterprise cluster resource ID"
  value       = azapi_resource.cluster[0].id
}

output "redis_cluster_name" {
  description = "Redis Enterprise cluster name"
  value       = azapi_resource.cluster[0].name
}

# Redis Enterprise database ID and name
output "redis_database_id" {
  description = "Redis Enterprise database resource ID"
  value       = azapi_resource.database[0].id
}

output "redis_database_name" {
  description = "Redis Enterprise database name"
  value       = azapi_resource.database[0].name
}

# Access keys for the Redis Enterprise database
output "redis_database_primary_key" {
  description = "Primary access key for the Redis Enterprise database"
  value       = data.azapi_resource_action.database_keys.output.primaryKey
  sensitive   = true
}

output "redis_database_secondary_key" {
  description = "Secondary access key for the Redis Enterprise database"
  value       = data.azapi_resource_action.database_keys.output.secondaryKey
  sensitive   = true
}