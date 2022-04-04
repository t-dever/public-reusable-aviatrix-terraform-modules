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

variable "aws_gov" {
  description = "If using AWS Gov set to true."
  type        = bool
  default     = false
}

variable "aviatrix_azure_primary_account_name" {
  description = "The Azure Primary Account name to be added to the Aviatrix Controller Access Accounts."
  type        = string
  default     = ""
}

variable "aviatrix_azure_primary_account_subscription_id" {
  description = "The Azure Primary Account Subscription ID to be added to the Aviatrix Controller Access Accounts."
  type        = string
  default     = ""
}

variable "aviatrix_azure_primary_account_tenant_id" {
  description = "The Azure Primary Account Tenant ID to be added to the Aviatrix Controller Access Accounts."
  type        = string
  default     = ""
}

variable "aviatrix_azure_primary_account_client_id" {
  description = "The Azure Primary Account Client ID to be added to the Aviatrix Controller Access Accounts."
  type        = string
  default     = ""
}

variable "aviatrix_azure_primary_account_client_secret" {
  description = "The Azure Primary Account Client Secret to be added to the Aviatrix Controller Access Accounts."
  type        = string
  default     = ""
  sensitive   = true
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

variable "copilot_username" {
  description = "Username of Copilot Account; Adds a account for CoPilot with ReadOnly Credentials. Must Provide variables 'copilot_username' and 'copilot_password'"
  type        = string
  default     = ""
}

variable "copilot_password" {
  description = "Password of Copilot Account; Adds a account for CoPilot with ReadOnly Credentials. Must Provide variables 'copilot_username' and 'copilot_password'"
  type        = string
  default     = ""
  sensitive   = true
}