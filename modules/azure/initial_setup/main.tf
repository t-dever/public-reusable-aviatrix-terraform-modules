terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.80.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.1.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.1.0"
    }
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
  skip_provider_registration = true
  storage_use_azuread        = true
}

locals {
  storage_account_name = replace("${var.resource_prefix}sa", "-", "")
}

data "azurerm_client_config" "current" {}
data "azurerm_resource_group" "resource_group" {
  name = "${var.resource_prefix}-rg"
}

resource "azurerm_log_analytics_workspace" "log_analytics" {
  name                = "${var.resource_prefix}-la"
  location            = data.azurerm_resource_group.resource_group.location
  resource_group_name = data.azurerm_resource_group.resource_group.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

data "azurerm_storage_account" "storage_account" {
  name                = local.storage_account_name
  resource_group_name = data.azurerm_resource_group.resource_group.name
}

# TODO: Figure out how to get this working with build agent in same region,
# TODO: network firewall rules don't apply to public IP's in the same region
# resource "azurerm_storage_account_network_rules" "storage_account_access_rules" {
#   storage_account_id = data.azurerm_storage_account.storage_account.id
#   default_action     = "Deny"
#   ip_rules           = [var.build_agent_ip_address, var.controller_user_public_ip_address]
#   bypass             = ["AzureServices"]
# }

resource "azurerm_storage_account" "backup_storage_account" {
  name                      = replace("${var.resource_prefix}backupsa", "-", "")
  resource_group_name       = data.azurerm_resource_group.resource_group.name
  location                  = data.azurerm_resource_group.resource_group.location
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  min_tls_version           = "TLS1_2"
  allow_blob_public_access  = false
  enable_https_traffic_only = true
}


resource "azurerm_storage_container" "controller_backup_container" {
  name                  = "controller-backup"
  storage_account_name  = azurerm_storage_account.backup_storage_account.name
  container_access_type = "private"
}

resource "azurerm_role_assignment" "storage_account_user_blob_owner" {
  scope                = data.azurerm_storage_account.storage_account.id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = var.user_principal_id
}

resource "azurerm_role_assignment" "storage_account_pipeline_contributor" {
  scope                = data.azurerm_storage_account.storage_account.id
  role_definition_name = "Storage Account Contributor"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_role_assignment" "storage_account_user_contributor" {
  scope                = data.azurerm_storage_account.storage_account.id
  role_definition_name = "Storage Account Contributor"
  principal_id         = var.user_principal_id
}

resource "azurerm_key_vault" "key_vault" {
  name                        = "${var.resource_prefix}-kv"
  location                    = data.azurerm_resource_group.resource_group.location
  resource_group_name         = data.azurerm_resource_group.resource_group.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  enable_rbac_authorization   = true
  sku_name                    = "standard"
  soft_delete_enabled         = true
  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
    ip_rules       = [var.build_agent_ip_address, var.controller_user_public_ip_address]
  }
}

resource "azurerm_role_assignment" "key_vault_pipeline_service_principal" {
  scope                = azurerm_key_vault.key_vault.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_role_assignment" "key_vault_user" {
  scope                = azurerm_key_vault.key_vault.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = var.user_principal_id
}

resource "time_sleep" "wait_1_minute" {
  depends_on = [
    azurerm_role_assignment.key_vault_pipeline_service_principal,
    azurerm_role_assignment.key_vault_user,
    azurerm_role_assignment.storage_account_pipeline_contributor,
    azurerm_role_assignment.storage_account_user_contributor,
    azurerm_role_assignment.storage_account_user_blob_owner
  ]
  create_duration = "1m"
}
