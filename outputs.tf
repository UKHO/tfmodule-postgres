output "fqdn" {
  value = azurerm_postgresql_flexible_server.this.fqdn
}

output "admin_password" {
  value     = random_password.postgres_admin_password.result
  sensitive = true
}
