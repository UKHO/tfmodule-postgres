# Bodge as azurerm_postgresql_flexible_server doesn't support 'Allow access to Azure services' setting yet
resource "azurerm_postgresql_flexible_server_firewall_rule" "azure_services" {
  name             = "azure-services-rule"
  server_id        = azurerm_postgresql_flexible_server.this.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "firewall_rules" {
  for_each = toset(var.ip_rules)

  name             = "IPAddress_${replace(each.value, ".", "")}"
  server_id        = azurerm_postgresql_flexible_server.this.id
  start_ip_address = each.value
  end_ip_address   = each.value
}