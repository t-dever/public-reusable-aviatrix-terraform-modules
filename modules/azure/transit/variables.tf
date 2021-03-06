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
  description = "Location of the resource group"
  type        = string
  default     = "South Central US"
}

variable "vnet_name" {
  type        = string
  description = "The name for the Virtual Network"
}

variable "vnet_address_prefix" {
  description = "The address prefix used in the vnet"
  type        = string
  default     = "10.0.0.0/23"
}

variable "transit_gateway_name" {
  type        = string
  description = "The name used for the transit gateway resource"
}

variable "transit_gw_size" {
  type        = string
  description = "The size of the transit gateways"
  default     = "Standard_B2ms"
}

variable "transit_gateway_ha" {
  type        = bool
  description = "Enable High Availability (HA) for transit gateways"
  default     = false
}

variable "transit_gateway_az_zone" {
  type        = string
  description = "The availability zone for the primary transit gateway"
  default     = "az-1"
}

variable "transit_gateway_ha_az_zone" {
  type        = string
  description = "The availability zone for the ha transit gateway"
  default     = "az-2"
}

variable "enable_transit_gateway_scheduled_shutdown" {
  type        = bool
  description = "Enable automatic shutdown on transit gateway."
  default     = false
}

variable "insane_mode" {
  type        = bool
  description = "Enable insane mode for transit gateway."
  default     = false
}

variable "aviatrix_azure_account" {
  description = "The account used to manage the transit gateway"
  type        = string
  sensitive   = true
  default     = "test-account"
}
variable "key_vault_id" {
  description = "The key vault id used to store the firewall password"
  type        = string
  sensitive   = true
  default     = "default"
}

variable "firenet_enabled" {
  description = "Enables firenet on the aviatrix transit gateway"
  type        = bool
  default     = false
}

variable "firewall_image" {
  type        = string
  description = "The firewall image to be used to deploy the NGFW's"
  default     = ""
}

variable "firewall_image_version" {
  description = "The firewall image version specific to the NGFW vendor image"
  type        = string
  default     = ""
}

variable "fw_instance_size" {
  description = "Azure Instance size for the NGFW's"
  type        = string
  default     = "Standard_D3_v2"
}

variable "firewall_name" {
  description = "The name of the firewall to be deployed."
  type        = string
}

variable "firewall_ha" {
  description = "Enables firewall High Availability by creating two firewalls in separate availability zones"
  type        = bool
  default     = false
}

variable "firewall_username" {
  type        = string
  description = "The username used for the firewall configurations"
  default     = "fwadmin"
}

variable "egress_enabled" {
  type        = bool
  default     = false
  description = "Allow traffic to the internet through firewall"
}

variable "allowed_public_ips" {
  description = "A list of allowed public IP's access to firewalls."
  type        = list(string)
  default     = []
  sensitive   = true
}

locals {
  # is_aviatrix                = length(regexall("aviatrix", lower(var.firewall_image))) > 0 # Check if fw image contains aviatrix.
  is_checkpoint             = length(regexall("check", lower(var.firewall_image))) > 0    # Check if fw image contains checkpoint.
  is_palo                   = length(regexall("palo", lower(var.firewall_image))) > 0     # Check if fw image contains palo.
  is_fortinet               = length(regexall("fortinet", lower(var.firewall_image))) > 0 # Check if fw image contains fortinet.
  cidrbits                  = tonumber(split("/", var.vnet_address_prefix)[1])
  transit_gateway_newbits   = var.insane_mode ? 26 - local.cidrbits : 28 - local.cidrbits
  netnum                    = pow(2, local.transit_gateway_newbits)
  firewall_newbits          = 28 - local.cidrbits
  transit_gateway_subnet    = cidrsubnet(var.vnet_address_prefix, local.transit_gateway_newbits, local.netnum - 2)
  transit_gateway_ha_subnet = cidrsubnet(var.vnet_address_prefix, local.transit_gateway_newbits, local.netnum - 1)
  firewall_subnet           = cidrsubnet(var.vnet_address_prefix, local.firewall_newbits, 0)
  firewall_wan_gateway      = cidrhost(local.firewall_subnet, 1)
  fortinet_bootstrap        = local.is_fortinet && var.egress_enabled ? templatefile("${path.module}/firewalls/fortinet/fortinet_egress_init.tftpl", { wan_gateway = local.firewall_wan_gateway }) : templatefile("${path.module}/firewalls/fortinet/fortinet_init.tftpl")
}
