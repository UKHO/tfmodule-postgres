resource "azurerm_postgresql_flexible_server_configuration" "postgres_log_checkpoints" {
  name      = "log_checkpoints"
  server_id = azurerm_postgresql_flexible_server.this.id
  value     = "on"
}
resource "azurerm_postgresql_flexible_server_configuration" "postgres_log_connections" {
  name      = "log_connections"
  server_id = azurerm_postgresql_flexible_server.this.id
  value     = "on"
}

resource "azurerm_postgresql_flexible_server_configuration" "postgres_log_connection_throttling" {
  count     = var.postgres_version < 18 ? 1 : 0

  name      = "connection_throttle.enable"
  server_id = azurerm_postgresql_flexible_server.this.id
  value     = "on"
}
