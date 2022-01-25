output "controller_subnet_id" {
  value       = azurerm_subnet.azure_controller_subnet.id
  description = "The subnet id for controller"
}

output "controller_resource_group_name" {
  value       = azurerm_resource_group.resource_group.name
  description = "The resource group name of the controller"
}

output "controller_admin_password" {
  value       = random_password.generate_controller_secret.result
  description = "The controller admin password"
  sensitive   = true
}

output "controller_public_ip" {
  value       = azurerm_linux_virtual_machine.aviatrix_controller_vm.public_ip_address
  description = "The IP Address of the Aviatrix Controller"
  sensitive   = true
}

output "resource_group_name" {
  value = azurerm_resource_group.resource_group.name
  description = "The resource group name"
}

output "resource_group_location" {
  value = azurerm_resource_group.resource_group.location
  description = "The resource group location"
}

output "controller_subnet_id" {
  value = azurerm_subnet.azure_controller_subnet.id
  description = "The controller subnet id"
}

# output "controller_security_group_name" {
#   value       = azurerm_network_security_group.controller_security_group.name
#   description = "The Controllers network security group"
#   sensitive   = true
# }

# output "user_public_ip_address" {
#   value       = var.controller_user_public_ip_address
#   description = "The public IP address of the User; used for NSG rules"
#   sensitive   = true
# }

# output "aviatrix_azure_account" {
#   value       = var.aviatrix_azure_access_account_name
#   description = "The Azure account provisioned in the aviatrix controller used for accessing subscriptions"
#   sensitive   = true
# }

