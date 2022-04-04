variable "controller_public_ip" {
  description = "The controllers public IP address."
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
  type        = string
  sensitive   = true
}

variable "aviatrix_access_account_name" {
  type        = string
  description = "The account name used to enable all the configuration settings."
}

variable "copilot_ip_address" {
  description = "The CoPilot IP Address to be associated to the controller."
  type        = string
  sensitive   = true
  default     = ""
}

variable "enable_security_group_management" {
  description = "Enables security group management."
  type        = bool
  default     = true
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

variable "enable_azure_backup" {
  description = "Enables Backups to azure storage account."
  type = object({
    backup_account_name   = string,
    backup_storage_name   = string,
    backup_container_name = string,
    backup_region         = string
  })
  default = {
    backup_account_name   = "",
    backup_storage_name   = "",
    backup_container_name = "",
    backup_region         = ""
  }
}
