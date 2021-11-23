output "resource_group_name" {
  value       = data.azurerm_resource_group.resource_group.name
  description = "The resource group name"
}

output "key_vault_name" {
  value       = azurerm_key_vault.key_vault.name
  description = "The key vault name"
  sensitive   = true
}

output "key_vault_id" {
  value       = azurerm_key_vault.key_vault.id
  description = "The key vault ID"
  sensitive   = true
}

output "storage_account_id" {
  value       = data.azurerm_storage_account.storage_account.id
  description = "The storage account ID"
}

output "storage_account_name" {
  value       = data.azurerm_storage_account.storage_account.name
  description = "The storage account name"
}

output "log_analytics_workspace_id" {
  value       = azurerm_log_analytics_workspace.log_analytics.workspace_id
  description = "The log analytics workspace id"
}

output "log_analytics_id" {
  value       = azurerm_log_analytics_workspace.log_analytics.id
  description = "The log analytics id"
}

output "log_analytics_name" {
  value       = azurerm_log_analytics_workspace.log_analytics.name
  description = "The log analytics name"
}
output "log_analytics_region" {
  value = data.azurerm_resource_group.resource_group.location
}
# output "controller_admin_password" {
#   value       = random_password.generate_controller_secret.result
#   description = "The controller admin password"
#   sensitive = true
# }

# output "azure_application_key" {
#   value       = var.azure_application_key
#   description = "The Application key for the service principal"
#   sensitive   = true
# }

# output "aviatrix_customer_id" {
#   value       = var.aviatrix_customer_id
#   description = "The customer id used for the azure controller"
#   sensitive   = true
# }
