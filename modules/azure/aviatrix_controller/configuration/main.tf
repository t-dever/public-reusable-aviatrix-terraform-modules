data "azurerm_client_config" "current" {}

# provider "azuread" {
#   version = "=0.7.0"
#   client_id = var.aws_client_id
#   subscription_id = var.aws_subscription_id
#   tenant_id = var.aws_tenant_id
#   client_secret = var.aws_client_secret
# }

# # Create an application
# resource "azuread_application" "app" {
#   name = var.azurerd_app_name
# }

# # Create a service principal
# resource "azuread_service_principal" "app" {
#   application_id = azuread_application.app.application_id
# }

resource "aviatrix_account" "azure_account" {
  account_name        = var.azure_account_name
  cloud_type          = 8
  arm_subscription_id = data.azurerm_client_config.current.subscription_id
  arm_directory_id    = data.azurerm_client_config.current.tenant_id
  arm_application_id  = data.azurerm_client_config.current.client_id
  arm_application_key = var.client_secret
}

resource "aviatrix_controller_security_group_management_config" "test_sqm_config" {
  depends_on = [
    aviatrix_account.azure_account
  ]
  account_name                     = var.azure_account_name
  enable_security_group_management = true
}