variable "aviatrix_controller_public_ip" {
  description = "The Public IP Address of the Aviatrix Controller."
  type        = string
}

variable "aviatrix_controller_private_ip" {
  description = "The Private IP Address of the Aviatrix Controller."
  type        = string
}

variable "aviatrix_controller_password" {
  description = "The password to be added to the admin account of the Aviatrix Controller"
  type        = string
  sensitive   = true
}

variable "aviatrix_controller_admin_email" {
  description = "The administrator email address to be added to the admin user in the Aviatrix Controller"
  type        = string
}

variable "aviatrix_controller_version" {
  description = "The version of the Aviatrix Controller."
  type        = string
  validation {
    condition     = can(regex("^[0-9].[0-9]", var.aviatrix_controller_version))
    error_message = "The aviatrix_controller_version value must be number dot number; example 6.5."
  }
}

variable "aviatrix_controller_customer_id" {
  description = "The license/customer id for the Aviatrix Controller."
  type        = string
}

variable "aviatrix_aws_primary_account_name" {
  description = "The AWS Primary Account name to be added to the Aviatrix Controller Access Accounts."
  type        = string
  default     = ""
}

variable "aviatrix_aws_primary_account_number" {
  description = "The AWS Account Number to be used with the primary AWS account."
  type        = string
  default     = ""
}

variable "aviatrix_aws_role_app_arn" {
  description = "The AWS role app ARN for the primary AWS account."
  type        = string
  default     = ""
}

variable "aviatrix_aws_role_ec2_arn" {
  description = "The AWS role ec2 ARN for the primary AWS account."
  type        = string
  default     = ""
}

variable "enable_security_group_management" {
  description = "Enables Auto Security Group Management within the Aviatrix Controller. A primary access account is required for implementation."
  type        = bool
  default     = true
}