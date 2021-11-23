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
  storage_use_azuread = true
}

data "azurerm_client_config" "current" {}
data "azurerm_resource_group" "resource_group" {
  name     = "${var.resource_prefix}-rg"
}

resource "azurerm_log_analytics_workspace" "log_analytics" {
  name                = "${var.resource_prefix}-la"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.resource_group.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

data "azurerm_storage_account" "storage_account" {
  name                      = replace("${var.resource_prefix}sa", "-", "")
  resource_group_name       = data.azurerm_resource_group.resource_group.name
}

resource "azurerm_storage_container" "controller_backup_container" {
  name                  = "controller-backup"
  storage_account_name  = data.azurerm_storage_account.storage_account.name
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
  location                    = var.location
  resource_group_name         = data.azurerm_resource_group.resource_group.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  enable_rbac_authorization   = true
  sku_name                    = "standard"
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



# resource "azurerm_key_vault_secret" "azure_subscription_id" {
#   depends_on = [
#     time_sleep.wait_1_minute
#   ]
#   name         = "arm-subscription-id"
#   value        = var.azure_subscription_id
#   key_vault_id = azurerm_key_vault.key_vault.id
# }

# resource "azurerm_key_vault_secret" "azure_tenant_id" {
#   depends_on = [
#     time_sleep.wait_1_minute
#   ]
#   name         = "arm-directory-id"
#   value        = var.azure_tenant_id
#   key_vault_id = azurerm_key_vault.key_vault.id
# }

# resource "azurerm_key_vault_secret" "azure_application_id" {
#   depends_on = [
#     time_sleep.wait_1_minute
#   ]
#   name         = "arm-application-id"
#   value        = var.azure_application_id
#   key_vault_id = azurerm_key_vault.key_vault.id
# }

# resource "azurerm_key_vault_secret" "azure_application_key" {
#   depends_on = [
#     time_sleep.wait_1_minute
#   ]
#   name         = "arm-application-key"
#   value        = var.azure_application_key
#   key_vault_id = azurerm_key_vault.key_vault.id
# }

# resource "azurerm_key_vault_secret" "aws_access_key" {
#   depends_on = [
#     time_sleep.wait_1_minute
#   ]
#   name         = "aws-access-key"
#   value        = var.aws_access_key
#   key_vault_id = azurerm_key_vault.key_vault.id
# }

# resource "azurerm_key_vault_secret" "aws_secret_key" {
#   depends_on = [
#     time_sleep.wait_1_minute
#   ]
#   name         = "aws-secret-key"
#   value        = var.aws_secret_key
#   key_vault_id = azurerm_key_vault.key_vault.id
# }

# resource "azurerm_key_vault_secret" "aws_account_number" {
#   depends_on = [
#     time_sleep.wait_1_minute
#   ]
#   name         = "aws-account-number"
#   value        = var.aws_account_number
#   key_vault_id = azurerm_key_vault.key_vault.id
# }

# resource "azurerm_key_vault_secret" "gcp_project_id" {
#   depends_on = [
#     time_sleep.wait_1_minute
#   ]
#   name         = "gcp-project-id"
#   value        = var.gcp_project_id
#   key_vault_id = azurerm_key_vault.key_vault.id
# }

# resource "azurerm_key_vault_secret" "gcp_secret_json" {
#   depends_on = [
#     time_sleep.wait_1_minute
#   ]
#   name         = "gcp-secret-json"
#   value        = jsonencode(var.gcp_secret_json)
#   key_vault_id = azurerm_key_vault.key_vault.id
# }

# resource "azurerm_key_vault_secret" "aviatrix_customer_id" {
#   depends_on = [
#     time_sleep.wait_1_minute
#   ]
#   name         = "aviatrix-customer-id"
#   value        = var.aviatrix_customer_id
#   key_vault_id = azurerm_key_vault.key_vault.id
# }
