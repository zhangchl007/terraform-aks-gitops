output "mysql_server_id" {
  description = "MySQL Flexible Server ID"
  value       = azurerm_mysql_flexible_server.mysql.id
}

output "mysql_server_name" {
  description = "MySQL Flexible Server name"
  value       = azurerm_mysql_flexible_server.mysql.name
}

output "mysql_database_name" {
  description = "MySQL database name"
  value       = azurerm_mysql_flexible_database.appdb.name
}

output "mysql_fqdn" {
  description = "MySQL Flexible Server FQDN"
  value       = azurerm_mysql_flexible_server.mysql.fqdn
  sensitive   = true
}

output "mysql_admin_login" {
  description = "MySQL admin login username"
  value       = azurerm_mysql_flexible_server.mysql.administrator_login
  sensitive   = true
}