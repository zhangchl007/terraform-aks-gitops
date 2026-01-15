output "eventhub_namespace_id" {
  description = "Event Hub Namespace ID"
  value       = azurerm_eventhub_namespace.eventhub.id
}

output "eventhub_namespace_name" {
  description = "Event Hub Namespace name"
  value       = azurerm_eventhub_namespace.eventhub.name
}

output "eventhub_id" {
  description = "Event Hub ID"
  value       = azurerm_eventhub.events.id
}

output "eventhub_name" {
  description = "Event Hub name"
  value       = azurerm_eventhub.events.name
}

output "private_endpoint_id" {
  description = "Private endpoint ID"
  value       = azurerm_private_endpoint.eventhub.id
}