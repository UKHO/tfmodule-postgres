variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string

  validation {
    condition     = length(var.resource_group_name) > 0
    error_message = "The vnet_resource_group_name variable must be supplied"
  }
}

variable "location" {
  description = "Azure region"
  type        = string

  validation {
    condition     = length(var.location) > 0
    error_message = "The location variable must be supplied"
  }
}

variable "tenant_id" {
  description = "Azure Tenant ID"
  type        = string

  validation {
    condition     = length(var.tenant_id) > 0
    error_message = "The tenant_id variable must be supplied"
  }
}

variable "postgres_name" {
  type = string

  validation {
    condition     = length(var.postgres_name) > 0
    error_message = "The postgres_name variable must be supplied"
  }
}

variable "short_name" {
  type = string

  validation {
    condition     = length(var.short_name) > 0
    error_message = "The short_name variable must be supplied"
  }
}

variable "postgres_sku" {
  type = string

  validation {
    condition     = length(var.postgres_sku) > 0
    error_message = "The postgres_sku variable must be supplied"
  }
}

variable "postgres_version" {
  type = string

  validation {
    condition     = length(var.postgres_version) > 0
    error_message = "The postgres_version variable must be supplied"
  }
}

variable "postgres_storage_mb" {
  type        = number
  description = "Postgres storage size in mb"

  validation {
    condition     = var.postgres_storage_mb > 0
    error_message = "The postgres_storage_mb variable must be supplied"
  }
}

variable "postgres_admin_user" {
  type        = string
  description = "Database server admin user name"

  validation {
    condition     = length(var.postgres_admin_user) > 0
    error_message = "The postgres_admin_user variable must be supplied"
  }
}

variable "postgres_storage_tier" {
  type        = string
  description = "Database server Storage Tier"

  validation {
    condition     = length(var.postgres_storage_tier) > 0
    error_message = "The postgres_storage_tier variable must be supplied"
  }
}

variable "vnet_name" {
  type = string

  validation {
    condition     = length(var.vnet_name) > 0
    error_message = "The vnet_name variable must be supplied"
  }
}

variable "vnet_resource_group_name" {
  type    = string
  default = "m-spokeconfig-rg"

  validation {
    condition     = length(var.vnet_resource_group_name) > 0
    error_message = "The vnet_resource_group_name variable must be supplied"
  }
}

variable "backup_retention_days" {
  type        = number
  description = "Backup retention period in days"
  default     = 35

  validation {
    condition     = var.backup_retention_days > 0
    error_message = "The backup_retention_days variable must be supplied"
  }
}

variable "auto_grow_enabled" {
  type        = bool
  description = "Enable auto grow"
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

  validation {
    condition     = length(var.databases) > 0
    error_message = "The databases variable must be supplied"
  }

  validation {
    condition = alltrue([
      for x in var.databases : length(x.name) > 0
    ])
    error_message = "All databases must have a name variable supplied"
  }
}

variable "tags" {
  description = "Tags for the resources"
  type        = map(string)
  default     = {}
}

variable "ip_rules" {
  description = "List of IP addresses that are allowed to access the AKS Cluster"
  type        = list(string)
  default     = []
}

# PE

variable "pe_enabled" {
  description = "Enable private endpoint"
  type        = bool
  default     = true
}

variable "pe_environment" {
    description = "environment for private endpoint (for example dev | prd | qa | pre)"
    default = ""

  validation {
    condition     = var.pe_enabled == true ? length(var.pe_environment) > 0 : true
    error_message = "The pe_environment variable must be supplied"
  }
}

variable "pe_subnet_name" {
  description = "subnet name that the private endpoint will associate"
  default     = ""

  validation {
    condition     = var.pe_enabled == true ? length(var.pe_subnet_name) > 0 : true
    error_message = "The pe_subnet_name variable must be supplied"
  }
}

variable "dns_resource_group_name" {
  description = "dns resource group name, please change domain-rg to either business-rg or engineering-rg"
  default     = ""

  validation {
    condition     = var.pe_enabled == true ? length(var.dns_resource_group_name) > 0 : true
    error_message = "The dns_resource_group_name variable must be supplied"
  }
}

variable "dns_zone_group_name" {
  description = "private dns zone group"
  default     = ""

  validation {
    condition     = var.pe_enabled == true ? length(var.dns_zone_group_name) > 0 : true
    error_message = "The dns_zone_group_name variable must be supplied"
  }
}

variable "dns_zone_name" {
  description = "alias to create private dns zone - be aware this is dependant on the endpoint"
  default     = "privatelink.azurewebsites.net"

  validation {
    condition     = var.pe_enabled == true ? length(var.dns_zone_name) > 0 : true
    error_message = "The dns_zone_name variable must be supplied"
  }
}