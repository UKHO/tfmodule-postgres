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

module "aks" {
  source                    = "github.com/UKHO/tfmodule-aks"
  resource_group_name       = azurerm_resource_group.this.name
  location                  = var.location_primary
  aks_name                  = "${local.resource_prefix}-aks"
  tenant_id                 = var.tenant_id
  subscription_id           = var.subscription_id
  principal_id              = data.azuread_service_principal.terraform.object_id
  aks_sku                   = var.aks_sku
  aks_kubernetes_version    = var.aks_kubernetes_version
  aks_system_node_vm_size   = var.aks_system_node_vm_size
  aks_system_node_disk_size = var.aks_system_node_disk_size
  aks_system_node_min_count = var.aks_system_node_min_count
  aks_system_node_max_count = var.aks_system_node_max_count
  vnet_subnet_id            = data.azurerm_subnet.spoke-nodes-subnet.id
  vnet_id                   = data.azurerm_virtual_network.spoke.id
  ip_rules                  = local.ip_rules
  tags                      = var.tags
  user_node_pools = [{
    name      = "linuxpool"
    os_type   = "Linux"
    vm_size   = var.aks_linux_node_vm_size
    disk_size = var.aks_linux_node_disk_size
    min_count = var.aks_linux_node_min_count
    max_count = var.aks_linux_node_max_count
  }]
}