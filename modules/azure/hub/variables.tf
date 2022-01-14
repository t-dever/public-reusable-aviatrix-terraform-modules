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

# variable "firewall_vendor" {
#   type = string
#   description = "The firewall vendor to deploy"

#   validation {
#     condition     = contains(["None", "PaloAlto", "Fortinet"], var.firewall_vendor)
#     error_message = "Valid values for var: firewall_vendor are ('None', 'PaloAlto', 'Fortinet'])"
#   } 
# }

variable "firewall_image" {
  type = object({
    firewall_image = string
    firewall_image_version = string
    firewall_size = string
    firewall_username = string
  })
  default = {
    firewall_image = "Palo Alto Networks VM-Series Next-Generation Firewall Bundle 1"
    firewall_image_version = "9.1.0"
    firewall_size          = "Standard_D3_v2"
    username               = "paloAdmin"
  }
}