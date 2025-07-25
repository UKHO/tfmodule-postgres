module "private_endpoint" {
  source    = "github.com/UKHO/tfmodule-azure-private-endpoint-private-link?ref=0.7.0"
  providers = {
    azurerm.spoke = azurerm
    azurerm.hub   = azurerm.hub
  }

  private_connection          = [azurerm_postgresql_flexible_server.this.id]
  zone_group                  = var.zone_group
  pe_identity                 = [azurerm_postgresql_flexible_server.this.name]
  pe_environment              = var.environment
  pe_vnet_rg                  = data.azurerm_resource_group.spoke_config.name
  pe_vnet_name                = data.azurerm_virtual_network.spoke.name
  pe_subnet_name              = data.azurerm_subnet.spoke-pe-subnet.name
  pe_resource_group           = [azurerm_resource_group.this.name]
  pe_resource_group_locations = [var.location_primary]
  dns_resource_group          = var.dns_resource_group
  subresource_names           = ["postgresqlServer"]
}

resource "terraform_data" "app_routing" {
  triggers_replace = [
    azurerm_postgresql_flexible_server.this.id,
  ]

  provisioner "local-exec" {
    when    = create
    command = "az aks approuting enable -n ${azurerm_postgresql_flexible_server.this.name} -g ${var.resource_group_name}"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "az aks approuting disable -n ${azurerm_postgresql_flexible_server.this.name} -g ${var.resource_group_name}"
  }
}