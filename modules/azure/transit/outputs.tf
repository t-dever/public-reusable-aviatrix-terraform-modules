output "transit_resource_group_name" {
  value       = azurerm_resource_group.azure_transit_resource_group.name
  description = "The transit resource group name"
}

output "transit_vnet_name" {
  value       = azurerm_virtual_network.azure_transit_vnet.name
  description = "The transit vnet name"
}

output "transit_address_prefix" {
  value       = azurerm_virtual_network.azure_transit_vnet.address_space[0]
  description = "The transit vnet address space"
}

output "transit_gateway_name" {
  value       = aviatrix_transit_gateway.azure_transit_gateway.gw_name
  description = "The transit gateway name"
}

output "firewall_1_mgmt_ip" {
  value       = var.firenet_enabled ? aviatrix_firewall_instance.firewall_instance_1[0].public_ip : null
  description = "The public IP address for firewall 1."
  sensitive = true
}

output "firewall_2_mgmt_ip" {
  value       = var.firenet_enabled && var.firewall_ha ? aviatrix_firewall_instance.firewall_instance_2[0].public_ip : null
  description = "The public IP address for firewall 2."
  sensitive = true
}

output "firewall_password" {
  value       = var.firenet_enabled ? random_password.generate_firewall_secret[0].result : null
  description = "The generated firewall password."
  sensitive   = true
}

output "firewall_1_api_key" {
  value       = var.firenet_enabled ? data.external.fortinet_bootstrap_1[0].result.api_key : null
  description = "The API Key for fortinet firewall 1."
  sensitive   = true
}

output "firewall_2_api_key" {
  value       = var.firenet_enabled ? data.external.fortinet_bootstrap_2[0].result.api_key : null
  description = "The API Key for fortinet firewall 2."
  sensitive   = true
}

output "firenet_enabled" {
  description = "Outputs true if firenet is enabled, used to auto add spokes to firewall policy for inspection"
  value = var.firenet_enabled ? true : false
}