output "controller_subnet_id" {
  value       = azurerm_subnet.azure_controller_subnet.id
  description = "The subnet id for controller"
}

output "controller_resource_group_name" {
  value       = azurerm_resource_group.resource_group.name
  description = "The resource group name of the controller"
}

output "controller_admin_username" {
  value       = var.aviatrix_controller_username
  description = "The controller admin username."
  sensitive   = true
}

output "controller_admin_password" {
  value       = var.aviatrix_controller_password == "" ? random_password.generate_aviatrix_controller_admin_secret[0].result : var.aviatrix_controller_password
  description = "The controller admin password"
  sensitive   = true
}

output "controller_public_ip" {
  value       = azurerm_linux_virtual_machine.aviatrix_controller_vm.public_ip_address
  description = "The Public IP Address of the Aviatrix Controller"
  sensitive   = true
}

output "controller_private_ip" {
  value       = azurerm_linux_virtual_machine.aviatrix_controller_vm.private_ip_address
  description = "The Private IP Address of the Aviatrix Controller"
  sensitive   = true
}

output "copilot_public_ip" {
  value       = var.aviatrix_deploy_copilot ? azurerm_linux_virtual_machine.aviatrix_copilot_vm[0].public_ip_address : null
  description = "The Public IP Address of the Aviatrix CoPilot Instance."
  sensitive   = true
}

output "copilot_private_ip" {
  value       = var.aviatrix_deploy_copilot ? azurerm_linux_virtual_machine.aviatrix_copilot_vm[0].private_ip_address : null
  description = "The Private IP Address of the Aviatrix CoPilot Instance"
  sensitive   = true
}

output "resource_group_name" {
  value       = azurerm_resource_group.resource_group.name
  description = "The resource group name"
}

output "resource_group_location" {
  value       = azurerm_resource_group.resource_group.location
  description = "The resource group location"
}

output "aviatrix_primary_access_account" {
  value = var.aviatrix_azure_primary_account_name
  description = "The azure primary account to be added in the Aviatrix Controller."
}