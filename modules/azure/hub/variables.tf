variable "resource_prefix" {
  description = "The prefix to the resource group that will be used for all created resources"
  type        = string
  default     = "test-resource-group"
}
variable "location" {
  description = "Location of the resource group"
  type        = string
  default     = "South Central US"
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
variable "vnet_address_prefix" {
  description = "The address prefix used in the vnet"
  type        = string
  default     = "10.0.0.0/23"
}
variable "gateway_mgmt_subnet_address_prefix" {
  description = "The subnet address prefix used for the gateway management ip"
  type        = string
  default     = "10.0.0.0/24"
}
variable "firewall_ingress_egress_prefix" {
  description = "The subnet address prefix used for the firewall ingress and egress"
  type        = string
  default     = "10.0.1.0/24"
}
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

variable "enable_firenet_egress" {
  description = "Enables egress traffic through firenet"
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
  is_checkpoint       = length(regexall("check", lower(var.firewall_image))) > 0 #Check if fw image contains checkpoint. Needs special handling for the username/password
  is_palo             = length(regexall("palo", lower(var.firewall_image))) > 0  #Check if fw image contains palo. Needs special handling for management_subnet (CP & Fortigate null)
  is_aviatrix         = length(regexall("aviatrix", lower(var.firewall_image))) > 0
  cidrbits            = tonumber(split("/", var.vnet_address_prefix)[1])
  firewall_lan_subnet = cidrhost(cidrsubnet(var.vnet_address_prefix, 28 - local.cidrbits, 3), 1)
}

