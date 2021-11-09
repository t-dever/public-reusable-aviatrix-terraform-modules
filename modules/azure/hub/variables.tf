variable "resource_prefix" {
  description = "The prefix to the resource group that will be used for all created resources"
}
variable "location" {
  description = "Location of the resource group"
}
variable "controller_public_ip" {
  default   = "1.2.3.4"
  sensitive = true
}
variable "controller_admin_password" {
  default   = "1.1.1.1"
  sensitive = true
}
variable "aviatrix_azure_account" {
  description = "The account used to manage the transit gateway"
  sensitive   = true
}
variable "vnet_address_prefix" {
  description = "The address prefix used in the vnet"
}
variable "gateway_mgmt_subnet_address_prefix" {
  description = "The subnet address prefix used for the gateway management ip"
}
variable "firewall_ingress_egress_prefix" {
  description = "The subnet address prefix used for the firewall ingress and egress"
}
variable "user_public_for_mgmt" {
  description = "The public IP address of the user that is logging into the controller"
  sensitive   = true
}
variable "key_vault_id" {
  description = "The key vault id used to store the firewall password"
  sensitive   = true
}
variable "firenet_enabled" {
  description = "Enables firenet on the aviatrix transit gateway"
  type        = bool
  default     = false
}
