variable "resource_prefix" {
  description = "The prefix to the resource group that will be used for all created resources"
}
variable "location" {
  description = "Location of the resource group"
}
variable "vnet_address_prefix" {
  description = "The address prefix used for the vnet e.g. 10.0.0.0/22"
}
variable "admin_email" {
  description = "The email address used for the aviatrix controller registration."
  sensitive   = true
}
variable "controller_customer_id" {
  description = "The customer id for the aviatrix controller"
  sensitive   = true
}
variable "controller_vm_size" {
  description = "The size for the controller VM."
  default = "Standard_A4_v2"
}
variable "copilot_vm_size" {
  description = "The size for the Co-Pilot VM."
  default = "Standard_D8as_v4"
}
variable "controller_admin_password" {
  description = "The password used for the admin account on the aviatrix controller."
  sensitive   = true
}
variable "controller_subnet_address_prefix" {
  description = "The subnet address prefix that's used for the controller and copilot VMs. e.g. 10.0.0.0/24"
}
variable "controller_user_public_ip_address" {
  description = "The public IP address of the user that is logging into the controller"
  sensitive   = true
}
variable "build_agent_ip_address" {
  description = "The Public IP Address of the build agent to add to the NSG allow rule"
  sensitive   = true
  default     = "1.1.1.1"
}
variable "network_watcher_name" {
  description = "The name of the network watcher instance for nsg flow logs."
}
variable "aviatrix_azure_access_account_name" {
  description = "The account used to manage the aviatrix controller in azure"
  sensitive   = true
}
variable "azure_application_key" {
  description = "The application/client secret/key to perform a backup restore"
  sensitive   = true
}
variable "log_analytics_workspace_id" {
  description = "The log analytics workspace id."
  sensitive   = true
}
variable "log_analytics_location" {
  description = "The log analytics location."
}
variable "log_analytics_id" {
  description = "The log analytics id."
}
variable "controller_version" {
  default = "UserConnect-6.5.2613"
}

variable "key_vault_id" {
  description = "The key vault ID where to store the admin credentials"
  sensitive   = true
}
