module "private_endpoint" {
  source    = "github.com/UKHO/tfmodule-azure-private-endpoint-private-link?ref=0.7.0"
  providers = {
    azurerm.spoke = azurerm.spoke
    azurerm.hub   = azurerm.hub
  }

  private_connection          = [azurerm_postgresql_flexible_server.this.id]
  pe_identity                 = [azurerm_postgresql_flexible_server.this.name]
  pe_environment              = var.pe_environment
  pe_vnet_rg                  = var.vnet_resource_group_name
  pe_vnet_name                = var.vnet_name
  pe_subnet_name              = var.pe_subnet_name
  pe_resource_group           = [var.resource_group_name]
  pe_resource_group_locations = [var.location]
  dns_resource_group          = var.dns_resource_group_name
  zone_group                  = local.zone_group
  dns_zone                    = local.dns_zone_name
  subresource_names           = ["postgresqlServer"]

  count = var.pe_enabled ? 1 : 0
}