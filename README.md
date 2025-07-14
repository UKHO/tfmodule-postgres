# Terraform Module: for AKS Clusters

##

## Required Resources

- `Resource Group` exists or is created external to the module.
- `Provider` must be created external to the module.

## Usage

```terraform
# Azure Key Vault and Azure App Config

## Usage Vars

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "tenant_id" {
  description = "Azure Tenant ID"
  type        = string
}

variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
}

variable "principal_id" {
  description = "The object id of the terraform principal (Optional). If not supplied then data.azurerm_client_config.current.object_id will be used"
  type        = string
}

variable "postgres_name" { 
  type = string
}

variable "short_name" { 
  type = string
}

variable "postgres_sku" { 
  type = string
}

variable "postgres_version" { 
  type = string
}

variable "postgres_storage_mb" {
  type        = string
  description = "Database server storage size"
}

variable "postgres_admin_user" {
  type        = string
  description = "Database server admin user name"
}

variable "postgres_storage_tier" {
  type        = string
  description = "Database server Storage Tier"
}

variable "vnet_id" { 
  type = string
}

variable "backup_retention_days" {
  type        = number
  description = "Backup retention period in days"
  default     = 30
}

variable "auto_grow_enabled" {
  type        = bool
  description = "Enable auto-grow"
  default     = false
}

variable "geo_redundant_backup_enabled" {
  type        = bool
  description = "Enable Geo-redundant Backup"
  default     = false
}

variable "public_network_access_enabled" {
  type        = bool
  description = "Enable Public Network Access"
  default     = false
}


variable "databases" {
  type = list(object({
    name      = string
    charset   = optional(string, "UTF8")
    collation = optional(string, "en_GB.utf8")
  }))
}

variable "tags" {
  description = "Tags for the resources"
  type        = map(string)
}

variable "ip_rules" {
  description = "List of IP addresses that are allowed to access the AKS Cluster"
  type        = list(string)
}

Example usage: 

locals {
  databases = [{
    name      = "example"
  }]
}

module "postgres" {
  source                        = "github.com/UKHO/tfmodule-postgres?ref=229597-postgres"
  resource_group_name           = azurerm_resource_group.this.name
  location                      = var.location_primary
  postgres_name                = "${local.resource_prefix}-postgres"
  short_name                    = local.resource_prefix_short
  tenant_id                     = var.tenant_id
  subscription_id               = var.subscription_id
  principal_id                  = data.azuread_service_principal.terraform.object_id
  postgres_sku                  = var.postgres_sku
  postgres_version              = var.postgres_version
  postgres_storage_mb           = var.postgres_storage_mb
  postgres_storage_tier         = var.postgres_storage_tier
  postgres_admin_user           = var.postgres_admin_user
  vnet_id                       = data.azurerm_virtual_network.spoke.id
  auto_grow_enabled             = true
  backup_retention_days         = 35
  geo_redundant_backup_enabled  = true
  public_network_access_enabled = true
  ip_rules                      = local.ip_rules
  tags                          = var.tags
  databases                     = local.databases
}