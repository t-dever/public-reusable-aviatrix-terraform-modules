variable "resource_prefix" {}
variable "location" {}
variable "vnet_address_prefix" {}
variable "gateway_subnet_address_prefix" {
  description = "The address prefix for gateway subnet in vnet"
}
variable "virtual_machines_subnet_address_prefix" {
  description = "The address prefix for virtual machines subnet in vnet"
}
variable "aviatrix_azure_account" {}
variable "transit_gateway_name" {}
variable "key_vault_id" {
  type = string
}
variable "controller_public_ip" {
  default   = "1.2.3.4"
  sensitive = true
}
variable "controller_admin_password" {
  default   = "1.1.1.1"
  sensitive = true
}