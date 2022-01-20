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

# variable "storage_account_name" {
#   description = "The name of the storage account."
#   type        = string
# }

variable "vnet_name" {
  type        = string
  description = "The name for the Virtual Network"
}

variable "vnet_address_prefix" {
  description = "The address prefix used in the vnet"
  type        = string
  default     = "10.0.0.0/23"
}

variable "primary_subnet_size" {
  description = "The cidr for the subnet used for virtual machines or other devices."
  type        = number
  default     = 28
}

variable "secondary_ha_subnet_size" {
  description = "The cidr for the subnet used for virtual machines or other devices for HA subnet."
  type        = number
  default     = 28
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

variable "controller_public_ip" {
  description = "The controllers public IP address."
  default     = "1.2.3.4"
  type        = string
  sensitive   = true
}
variable "aviatrix_azure_account" {
  description = "The account used to manage the transit gateway"
  type        = string
  sensitive   = true
  default     = "test-account"
}

variable "firewall_name" {
  description = "The name of the firewall to be deployed."
  type        = string
}
# variable "firewall_ingress_egress_prefix" {
#   description = "The subnet address prefix used for the firewall ingress and egress"
#   type        = string
#   default     = "10.0.1.0/24"
# }
variable "user_public_for_mgmt" {
  description = "The public IP address of the user that is logging into the controller"
  type        = string
  sensitive   = true
  default     = "1.1.1.1"
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

locals {
  is_checkpoint              = length(regexall("check", lower(var.firewall_image))) > 0    #Check if fw image contains checkpoint. Needs special handling for the username/password
  is_palo                    = length(regexall("palo", lower(var.firewall_image))) > 0     #Check if fw image contains palo. Needs special handling for management_subnet (CP & Fortigate null)
  is_fortinet                = length(regexall("fortinet", lower(var.firewall_image))) > 0 #Check if fw image contains fortinet. Needs special handling for management_subnet (CP & Fortigate null)
  is_aviatrix                = length(regexall("aviatrix", lower(var.firewall_image))) > 0
  cidrbits                   = tonumber(split("/", var.vnet_address_prefix)[1])
  firewall_lan_subnet        = cidrhost(cidrsubnet(var.vnet_address_prefix, 28 - local.cidrbits, 3), 1)
  transit_gateway_newbits    = var.insane_mode ? 26 - local.cidrbits : 28 - local.cidrbits
  transit_gateway_ha_newbits = var.insane_mode ? 26 - local.cidrbits : 28 - local.cidrbits
  subnets                    = cidrsubnets(var.vnet_address_prefix, local.transit_gateway_newbits, local.transit_gateway_ha_newbits, 28 - local.cidrbits, var.primary_subnet_size, var.secondary_ha_subnet_size)
  transit_gateway_subnet     = local.subnets[0]
  transit_gateway_ha_subnet  = local.subnets[1]
  firewall_subnet            = local.subnets[2]
  # primary_subnet            = local.subnets[3]
  # secondary_subnet          = local.subnets[4]
  # transit_gateway_subnet    = cidrsubnet(var.vnet_address_prefix, local.transit_gateway_newbits, 0)
  # transit_gateway_ha_subnet = cidrsubnet(var.vnet_address_prefix, local.transit_gateway_ha_newbits, 1)
  # firewall_subnet           = cidrsubnets(var.vnet_address_prefix, local.transit_gateway_newbits, local.transit_gateway_ha_newbits, 28)[2]
  # primary_subnet            = cidrsubnets(var.vnet_address_prefix, local.transit_gateway_newbits, local.transit_gateway_ha_newbits, 28, var.primary_subnet_size)[3]
  # transit_gateway_ha_subnet = var.insane_mode ? cidrsubnet(var.vnet_address_prefix, 26 - local.cidrbits, 1) : cidrsubnet(var.vnet_address_prefix, 28 - local.cidrbits, 1)
  # firewall_subnet           = var.insane_mode ? cidrsubnets(var.vnet_address_prefix, 26 - local.cidrbits, 26 - local.cidrbits, 28 - local.cidrbits)[2] : cidrsubnets(var.vnet_address_prefix, 28 - local.cidrbits, 28 - local.cidrbits, 28 - local.cidrbits)[2]
  # primary_subnet            = var.insane_mode ? cidrsubnets(var.vnet_address_prefix, 26 - local.cidrbits, 26 - local.cidrbits, 28 - local.cidrbits, 28 - local.cidrbits)[3] : cidrsubnets(var.vnet_address_prefix, 28 - local.cidrbits, 28 - local.cidrbits, 28 - local.cidrbits, 28 - local.cidrbits)[3]
  # secondary_subnet            = var.insane_mode ? cidrsubnets(var.vnet_address_prefix, 26 - local.cidrbits, 26 - local.cidrbits, 28 - local.cidrbits, 28 - local.cidrbits, 28 - local.cidrbits)[3] : cidrsubnets(var.vnet_address_prefix, 28 - local.cidrbits, 28 - local.cidrbits, 28 - local.cidrbits, 28 - local.cidrbits)[3]
}

