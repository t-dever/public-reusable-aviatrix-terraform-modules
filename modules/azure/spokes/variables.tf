variable "resource_prefix" {
  description = "The resource prefix to use as the prefix for all resource names."
}
variable "location" {
  description = "The location used for deployment of resources."
  type = string
}
variable "vnet_address_prefix" {
  description = "The address prefix used for the virtual network."
  type = string
}
variable "gateway_subnet_address_prefix" {
  description = "The address prefix for gateway subnet in vnet."
  type = string
}
variable "virtual_machines_subnet_address_prefix" {
  description = "The address prefix for virtual machines subnet in vnet."
  type = string
}
variable "aviatrix_azure_account" {
  description = "The name of the account configured in the Aviatrix Controller."
  type = string
}
variable "transit_gateway_name" {}
variable "controller_username" {
  description = "The name for the Aviatrix Controller login."
  type = string
  default = "admin"
  sensitive = true
}
variable "key_vault_id" {
  description = "The key vault id where the virtual machine secret will be stored."
  type = string
}
variable "controller_public_ip" {
  description = "The Aviatrix Controller public IP Address."
  type = string
  sensitive = true
}
variable "controller_password" {
  description = "The Aviatrix Controller admin credentials."
  type = string
  sensitive = true
}