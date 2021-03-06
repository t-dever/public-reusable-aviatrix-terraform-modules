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

output "storage_account_backup_name" {
  value       = azurerm_storage_account.backup_storage_account.name
  description = "The storage account name"
}

output "storage_account_backup_container_name" {
  value       = azurerm_storage_container.controller_backup_container.name
  description = "The name of the container where backups will be stored."
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
  value       = data.azurerm_resource_group.resource_group.location
  description = "The log analytics regions/location"
}

output "public_key_openssh" {
  description = "The public key created for the private key."
  value       = var.generate_private_ssh_key ? azurerm_key_vault_key.generated_ssh_private_key[0].public_key_openssh : null
  sensitive   = true
}
