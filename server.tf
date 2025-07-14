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
