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

output "firewall_mgmt_ip" {
  value       = aviatrix_firewall_instance.firewall_instance[0].public_ip
  description = "The public IP addresses for firewalls"
  # value = var.firenet_enabled ? aviatrix_firewall_instance.palo_firewall_instance[count.index].public_ip : null
  sensitive = true
}

output "firewall_password" {
  value = random_password.generate_firewall_secret[0].result
  description = "The generated firewall password."
  sensitive = true
}

output "api_key" {
  value = data.external.fortinet_bootstrap[*].result.api_key
  description = "The API Key for fortinet firewall."
  sensitive = true
}