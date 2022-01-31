output "spoke_resource_group_name" {
  value       = azurerm_resource_group.azure_spoke_resource_group.name
  description = "The spoke resource group name"
}

output "spoke_vnet_name" {
  value       = azurerm_virtual_network.azure_spoke_vnet.name
  description = "The spoke vnet name"
}

output "spoke_address_prefix" {
  value       = azurerm_virtual_network.azure_spoke_vnet.address_space[0]
  description = "The spoke vnet address space"
}

output "spoke_gateway_name" {
  value       = aviatrix_spoke_gateway.spoke_gateway.gw_name
  description = "The spoke gateway name"
}

output "spoke_segmentation_domain_name" {
  value       = var.segmentation_domain_name
  description = "The name of the segmentation domain created for the spoke."
}
