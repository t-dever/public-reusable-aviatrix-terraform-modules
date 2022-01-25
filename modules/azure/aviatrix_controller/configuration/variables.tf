variable "azure_account_name" {
  type        = string
  description = "The account name to add to the controller"
}

variable "client_secret" {
  type        = string
  description = "The Client secret for the account to be added"
}

variable "controller_public_ip" {
  description = "The controllers public IP address."
  default     = "1.2.3.4"
  type        = string
  sensitive   = true
}

variable "controller_private_ip" {
  description = "The controllers private IP address."
  default     = "1.2.3.4"
  type        = string
  sensitive   = true
}

variable "controller_username" {
  description = "The controllers username."
  default     = "admin"
  type        = string
  sensitive   = true
}

variable "controller_password" {
  description = "The controllers password."
  default     = ""
  type        = string
  sensitive   = true
}

variable "copilot_public_ip" {
  description = "The CoPilots Public IP Address."
  type        = string
  sensitive   = true
  default     = ""
}

variable "copilot_private_ip" {
  description = "The CoPilots Private IP Address"
  type        = string
  sensitive   = true
  default     = ""
}

variable "resource_group_name" {
  description = "The name of the controller resource group"
  type        = string
}

variable "resource_group_location" {
  description = "The name of the controller resource group location"
  type        = string
}

variable "controller_user_public_ip_address" {
  description = "The public IP address of the user that is logging into the controller"
  type        = string
  sensitive   = true
}

variable "controller_subnet_id" {
  description = "The controller subnet id."
  type        = string
}
