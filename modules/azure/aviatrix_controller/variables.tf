variable "location" {
  description = "Location of the resource group"
  type        = string
  default     = "South Central US"
}

variable "resource_group_name" {
  description = "The resource group name to be created."
  type        = string
  default     = "aviatrix-controller"
}

variable "vnet_name" {
  type        = string
  description = "The name for the Virtual Network"
  default     = "aviatrix-controller-vnet"
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

variable "aviatrix_controller_security_group_name" {
  description = "The name of the security group for the Aviatrix Controller."
  type        = string
  default     = "aviatrix-controller-security-group"
}

variable "allowed_ips" {
  description = "List of allowed ips to be added as ingress rule for security group."
  type        = list(string)
  default     = []
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

variable "aviatrix_controller_password" {
  description = "The password to be applied to the aviatrix controller admin account."
  type        = string
  sensitive   = true
  default     = ""
}

variable "aviatrix_controller_instance_size" {
  description = "Aviatrix Controller instance size."
  type        = string
  default     = "Standard_D2as_v4"
}

variable "aviatrix_controller_marketplace_image" {
  description = "The values for the aviatrix controller marketplace image."
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
  default = {
    publisher = "aviatrix-systems"
    offer     = "aviatrix-controller"
    sku       = "aviatrix-controller-g3"
    version   = "latest"
  }
}

variable "aviatrix_controller_version" {
  description = "The version used for the controller"
  type        = string
  default     = "6.6"
  validation {
    condition     = can(regex("^[0-9].[0-9]", var.aviatrix_controller_version))
    error_message = "The aviatrix_controller_version value must be number dot number; example 6.5."
  }
}

variable "aviatrix_controller_customer_id" {
  description = "The customer id for the aviatrix controller"
  type        = string
  sensitive   = true
  default     = ""
}

variable "aviatrix_controller_public_ssh_key" {
  type        = string
  description = "Use a public SSH key for authentication to Aviatrix Controller"
  default     = ""
}

variable "aviatrix_controller_virtual_machine_admin_username" {
  type        = string
  description = "Admin Username for the controller virtual machine."
  default     = "aviatrix"
}

variable "aviatrix_controller_virtual_machine_admin_password" {
  type        = string
  description = "Admin Password for the controller virtual machine."
  default     = ""
  sensitive   = true
}

variable "aviatrix_controller_admin_email" {
  description = "The email address used for the aviatrix controller registration."
  type        = string
  sensitive   = true
  default     = ""
}

variable "aviatrix_enable_security_group_management" {
  description = "Enables Auto Security Group Management within the Aviatrix Controller. A primary access account is required for implementation."
  type        = bool
  default     = true
}

variable "aviatrix_azure_primary_account_name" {
  description = "The Azure Primary Account name to be added to the Aviatrix Controller Access Accounts."
  type        = string
  default     = ""
}

variable "aviatrix_azure_primary_account_client_secret" {
  description = "The Azure Primary Account Client Secret to be added to the Aviatrix Controller Access Accounts."
  type        = string
  default     = ""
  sensitive   = true
}

variable "aviatrix_deploy_copilot" {
  description = "Deploy Aviatrix CoPilot?"
  type        = bool
  default     = true
}

variable "aviatrix_copilot_marketplace_image" {
  description = "The values for the aviatrix copilot marketplace image."
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
  default = {
    publisher = "aviatrix-systems"
    offer     = "aviatrix-copilot"
    sku       = "avx-cplt-byol-01"
    version   = "latest"
  }
}

variable "aviatrix_copilot_name" {
  description = "The name of the CoPilot VM."
  type        = string
  default     = "aviatrix-copilot-vm"
}

variable "aviatrix_copilot_virtual_machine_admin_username" {
  type        = string
  description = "Admin Username for the copilot virtual machine."
  default     = "aviatrix"
}

variable "aviatrix_copilot_virtual_machine_admin_password" {
  type        = string
  description = "Admin Password for the copilot virtual machine."
  default     = ""
  sensitive   = true
}

variable "aviatrix_copilot_public_ssh_key" {
  type        = string
  description = "Use a public SSH key for local. authentication to Aviatrix Copilot."
  default     = ""
}

variable "aviatrix_copilot_instance_size" {
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
