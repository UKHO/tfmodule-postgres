resource "azurerm_postgresql_flexible_server_database" "databases" {
  for_each = { for i, s in var.databases : i => s }

  name      = each.value.name
  server_id = azurerm_postgresql_flexible_server.this.id
  charset   = each.value.charset
  collation = each.value.collation
}