output "hub_resource_group_name" {
  value       = azurerm_resource_group.azure_hub_resource_group.name
  description = "The hub resource group name"
}

output "hub_vnet_name" {
  value       = azurerm_virtual_network.azure_hub_vnet.name
  description = "The hub vnet name"
}

output "hub_address_prefix" {
  value       = azurerm_virtual_network.azure_hub_vnet.address_space[0]
  description = "The hub vnet address space"
}

output "transit_gateway_name" {
  value       = aviatrix_transit_gateway.azure_transit_gateway.gw_name
  description = "The transit gateway name"
}

output "firewall_mgmt_ip" {
  count = var.firenet_enabled ? 1: 0
  value = aviatrix_firewall_instance.palo_firewall_instance.public_ip
  sensitive = true
}
