resource "azurerm_postgresql_flexible_server" "this" {
  name                = var.postgres_name
  resource_group_name = var.resource_group_name
  location            = var.location

  lifecycle {
    prevent_destroy = false
    ignore_changes  = [tags, storage_mb, zone]
  }

  sku_name                      = var.postgres_sku
  storage_mb                    = var.postgres_storage_mb
  storage_tier                  = var.postgres_storage_tier
  auto_grow_enabled             = var.auto_grow_enabled
  backup_retention_days         = var.backup_retention_days
  geo_redundant_backup_enabled  = var.geo_redundant_backup_enabled
  administrator_login           = var.postgres_admin_user
  administrator_password        = random_password.postgres_admin_password.result
  version                       = var.postgres_version
  public_network_access_enabled = var.public_network_access_enabled
}

resource "random_password" "postgres_admin_password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "azurerm_postgresql_flexible_server_database" "databases" {
  for_each = { for i, s in var.databases : i => s }

  name      = each.value.name
  server_id = azurerm_postgresql_flexible_server.this.id
  charset   = each.value.charset
  collation = each.value.collation
}

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
  name      = "connection_throttle.enable"
  server_id = azurerm_postgresql_flexible_server.this.id
  value     = "on"
}

resource "azurerm_private_dns_zone" "postgres_private_dns" {
  name                = "${var.short_name}.postgres.database.azure.com"
  resource_group_name = var.resource_group_name
  lifecycle {
    ignore_changes = [
      tags
    ]
  }

  depends_on = [azurerm_postgresql_flexible_server.this]
}

resource "azurerm_private_dns_zone_virtual_network_link" "postgres_private_dns_link" {
  name                  = "${var.short_name}vnetzone.com"
  private_dns_zone_name = azurerm_private_dns_zone.postgres_private_dns.name
  virtual_network_id    = var.vnet_id
  resource_group_name   = var.resource_group_name
  lifecycle {
    ignore_changes = [
      tags
    ]
  }

  depends_on = [azurerm_postgresql_flexible_server.this]
}

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
