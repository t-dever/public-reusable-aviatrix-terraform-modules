variable "resource_prefix" {
  description = "The resource prefix to use as the prefix for all resource names."
  type        = string
}
variable "location" {
  description = "The location used for deployment of resources."
  type        = string
}
variable "vnet_address_prefix" {
  description = "The address prefix used for the virtual network."
  type        = string
}
variable "gateway_subnet_address_prefix" {
  description = "The address prefix for gateway subnet in vnet."
  type        = string
}
variable "virtual_machines_subnet_address_prefix" {
  description = "The address prefix for virtual machines subnet in vnet."
  type        = string
}
variable "aviatrix_azure_account" {
  description = "The name of the account configured in the Aviatrix Controller."
  type        = string
}
variable "transit_gateway_name" {
  description = "The transit gateway name the spoke will be peered with."
  type        = string
}
variable "key_vault_id" {
  description = "The key vault id where the virtual machine secret will be stored."
  type        = string
}

variable "firenet_inspection" {
  description = "Tells the subnet to be inspected by firewalls if configured"
  type        = bool
  default     = false
}

variable "segmentation_domain_name" {
  description = "The segmentation domain name"
  type        = string
}

variable "segmentation_domain_connection_policies" {
  description = "The segementation domain connection policies to associate to the spoke."
  type = list()
}