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

output "testing" {
  value = null_resource.test_null_resource
}