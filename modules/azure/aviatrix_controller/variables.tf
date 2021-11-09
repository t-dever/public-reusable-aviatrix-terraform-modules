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
}
variable "controller_customer_id" {
  description = "The customer id for the aviatrix controller"
}
variable "controller_admin_password" {
  description = "The password used for the admin account on the aviatrix controller."
}
variable "controller_subnet_address_prefix" {
  description = "The subnet address prefix that's used for the controller and copilot VMs. e.g. 10.0.0.0/24"
}
variable "controller_user_public_ip_address" {
  description = "The public IP address of the user that is logging into the controller"
}
variable "network_watcher_name" {
  description = "The name of the network watcher instance for nsg flow logs."
}
variable "aviatrix_azure_access_account_name" {
  description = "The account used to manage the aviatrix controller in azure"
}
variable "azure_application_key" {
  description = "The application/client secret/key to perform a backup restore"
}
variable "log_analytics_workspace_id" {
  description = "The log analytics workspace id."
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
