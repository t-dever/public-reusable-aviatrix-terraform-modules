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

variable "enable_security_group_management" {
  description = "Enables security group management."
  type = bool
  default = true
}

variable "enable_netflow_to_copilot" {
  description = "Enables netflow logging to CoPilot."
  type        = bool
  default     = false
}

variable "netflow_port" {
  description = "The port used for netflow data."
  type        = string
  default     = "31283"
}

variable "enable_rsyslog_to_copilot" {
  description = "Enables rsyslog logging to CoPilot."
  type        = bool
  default     = false
}

variable "rsyslog_port" {
  description = "The port used for rsyslog data."
  type        = string
  default     = "5000"
}

variable "rsyslog_protocol" {
  description = "The protocol used for rsyslog."
  type        = string
  default     = "UDP"
  validation {
    condition     = contains(["TCP", "UDP"], var.rsyslog_protocol)
    error_message = "Valid values for var: rsyslog_protocol are (TCP or UDP)."
  }
}

variable "enable_backup" {
  description = "Enable backup for the aviatrix controller."
  type        = bool
  default     = false
}

variable "backup_storage_name" {
  description = "The name of the storage account to store backups for the aviatrix controller."
  type        = string
  default     = ""
}

variable "backup_container_name" {
  description = "The name of the storage account container to store backups for the aviatrix controller."
  type        = string
  default     = ""
}

variable "backup_region" {
  description = "The region where the storage account is stored."
  type        = string
  default     = ""
}