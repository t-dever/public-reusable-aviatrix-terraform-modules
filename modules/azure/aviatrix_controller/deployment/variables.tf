variable "location" {
  description = "Location of the resource group"
  type        = string
}

variable "resource_group_name" {
  description = "The resource group name to be created."
  type        = string
}

variable "vnet_name" {
  type        = string
  description = "The name for the Virtual Network"
}

variable "vnet_address_prefix" {
  description = "The address prefix used for the vnet e.g. 10.0.0.0/22"
  type        = string
  default     = "10.0.0.0/23"
}

variable "controller_subnet_address_prefix" {
  description = "The subnet address prefix that's used for the controller and copilot VMs. e.g. 10.0.0.0/24"
  type        = string
  default     = "10.0.0.0/24"
}

variable "aviatrix_controller_name" {
  description = "The name of the azure virtual machine resource."
  type        = string
  default     = "aviatrix-controller-vm"
}

variable "aviatrix_controller_username" {
  description = "The username to be applied to the aviatrix controller for admin access."
  type        = string
  sensitive   = true
  default     = "admin"
}

variable "controller_vm_size" {
  description = "The size for the controller VM."
  type        = string
  default     = "Standard_A4_v2"
}

variable "controller_version" {
  description = "The version used for the controller"
  type        = string
  default     = "UserConnect-6.5.2613"
}

variable "controller_customer_id" {
  description = "The customer id for the aviatrix controller"
  type        = string
  sensitive   = true
}

variable "controller_public_ssh_key" {
  type        = string
  description = "Use a public SSH key for authentication to Aviatrix Controller"
  default     = ""
}

variable "controller_virtual_machine_admin_username" {
  type        = string
  description = "Admin Username for the controller virtual machine."
  default     = "aviatrix"
}

variable "controller_virtual_machine_admin_password" {
  type        = string
  description = "Admin Password for the controller virtual machine."
  default     = ""
  sensitive   = true
}

variable "admin_email" {
  description = "The email address used for the aviatrix controller registration."
  type        = string
  sensitive   = true
}

variable "deploy_copilot" {
  description = "Deploy Aviatrix CoPilot?"
  type        = bool
  default     = false
}

variable "copilot_name" {
  description = "The name of the CoPilot VM."
  type        = string
  default     = "Standard_D8as_v4"
}

variable "copilot_virtual_machine_admin_username" {
  type        = string
  description = "Admin Username for the copilot virtual machine."
  default     = "aviatrix"
}

variable "copilot_virtual_machine_admin_password" {
  type        = string
  description = "Admin Password for the copilot virtual machine."
  default     = ""
  sensitive   = true
}

variable "copilot_public_ssh_key" {
  type        = string
  description = "Use a public SSH key for local. authentication to Aviatrix Copilot."
  default     = ""
}

variable "copilot_vm_size" {
  description = "The size for the CoPilot VM."
  type        = string
  default     = "Standard_D8as_v4"
}

variable "enable_scheduled_shutdown" {
  type        = bool
  description = "Enable automatic shutdown on controller and copilot gateway."
  default     = true
}

variable "enable_spot_instances" {
  description = "Make the controller and copilot spot instances for best effort or development workloads."
  type        = bool
  default     = true
}

variable "store_credentials_in_key_vault" {
  description = "Elect to store the generated admin credentials in the key vault"
  type        = bool
  default     = false
}

variable "key_vault_id" {
  description = "The key vault ID where to store the admin credentials"
  type        = string
  sensitive   = true
  default     = ""
}

locals {
  controller_private_ip = cidrhost(var.controller_subnet_address_prefix, 4)
  copilot_private_ip    = cidrhost(var.controller_subnet_address_prefix, 5)
}
