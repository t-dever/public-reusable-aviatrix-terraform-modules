variable "controller_username" {
  description = "The controllers username."
  default     = "admin"
  type        = string
  sensitive   = true
}

variable "controller_password" {
  description = "The controllers password."
  type        = string
  sensitive   = true
}

variable "controller_public_ip" {
  description = "The controllers public IP address."
  default     = "1.2.3.4"
  type        = string
  sensitive   = true
}

variable "resource_group_name" {
  description = "The resource group name to be created."
  type        = string
  default     = "test-resource-group"
}

variable "location" {
  description = "The location used for deployment of resources."
  type        = string
}

variable "storage_account_name" {
  description = "The name of the storage account."
  type        = string
}

variable "vnet_name" {
  type        = string
  description = "The name for the Virtual Network"
}

variable "vnet_address_prefix" {
  description = "The address prefix used for the virtual network."
  type        = string
}

# variable "gateway_subnet_address_prefix" {
#   description = "The address prefix for gateway subnet in vnet."
#   type        = string
# }

variable "spoke_gateway_name" {
  type        = string
  description = "The name used for the spoke gateway resource"
}

variable "test_vm_name" {
  type        = string
  description = "The name used for the test virtual machine resource"
}

variable "spoke_gateway_ha" {
  type        = bool
  description = "Enable High Availability (HA) for spoke gateways"
  default     = false
}

variable "spoke_gw_size" {
  type        = string
  description = "The size of the spoke gateways"
  default     = "Standard_B1ms"
}

variable "virtual_machines_subnet_size" {
  description = "The cidr size for virtual machines subnet in vnet."
  type        = number
  default     = 28
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

variable "insane_mode" {
  type        = bool
  description = "Enable insane mode for transit gateway."
  default     = false
}

variable "spoke_gateway_az_zone" {
  type        = string
  description = "The availability zone for the primary spoke gateway"
  default     = "az-1"
}

variable "spoke_gateway_ha_az_zone" {
  type        = string
  description = "The availability zone for the ha spoke gateway"
  default     = "az-2"
}

locals {
  cidrbits                   = tonumber(split("/", var.vnet_address_prefix)[1])
  spoke_gateway_newbits      = var.insane_mode ? 26 - local.cidrbits : 28 - local.cidrbits
  spoke_gateway_ha_newbits   = var.insane_mode ? 26 - local.cidrbits : 28 - local.cidrbits
  virtual_machine_newbits    = var.virtual_machines_subnet_size - local.cidrbits
  subnets                    = cidrsubnets(var.vnet_address_prefix, local.spoke_gateway_newbits, local.spoke_gateway_ha_newbits, local.virtual_machine_newbits)
  spoke_gateway_subnet       = local.subnets[0]
  spoke_gateway_ha_subnet    = local.subnets[1]
  virtual_machine_subnet     = local.subnets[2]
}