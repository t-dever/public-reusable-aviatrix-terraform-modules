variable "resource_prefix" {
  description = "The prefix to the resource group that will be used for all created resources"
  type        = string
}
variable "location" {
  description = "Location of the resource group"
  type        = string
}
variable "controller_public_ip" {
  description = "The controllers public IP address."
  default     = "1.2.3.4"
  type        = string
  sensitive   = true
}
variable "controller_admin_password" {
  description = "The controllers admin password"
  default     = "1.1.1.1"
  type        = string
  sensitive   = true
}
variable "aviatrix_azure_account" {
  description = "The account used to manage the transit gateway"
  type        = string
  sensitive   = true
}
variable "vnet_address_prefix" {
  description = "The address prefix used in the vnet"
  type        = string
}
variable "gateway_mgmt_subnet_address_prefix" {
  description = "The subnet address prefix used for the gateway management ip"
  type        = string
}
variable "firewall_ingress_egress_prefix" {
  description = "The subnet address prefix used for the firewall ingress and egress"
  type        = string
}
variable "user_public_for_mgmt" {
  description = "The public IP address of the user that is logging into the controller"
  type        = string
  sensitive   = true
}
variable "key_vault_id" {
  description = "The key vault id used to store the firewall password"
  type        = string
  sensitive   = true
}
variable "firenet_enabled" {
  description = "Enables firenet on the aviatrix transit gateway"
  type        = bool
  default     = false
}
