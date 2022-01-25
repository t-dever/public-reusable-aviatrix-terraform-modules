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

resource "aviatrix_controller_security_group_management_config" "security_group_management" {
  depends_on = [
    aviatrix_account.azure_account
  ]
  account_name                     = var.azure_account_name
  enable_security_group_management = true
}

resource "azurerm_network_security_group" "controller_security_group" {
  depends_on = [
    aviatrix_controller_security_group_management_config.security_group_management
  ]
  lifecycle {
    ignore_changes = [security_rule]
  }
  name                = "Aviatrix-SG-${var.controller_ip}" # GROSSS
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
}

resource "azurerm_network_security_rule" "allow_user_to_controller_nsg" {
  name                        = "AllowUserHttpsInboundToController"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = var.controller_user_public_ip_address
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.controller_security_group.name
}

# resource "azurerm_network_security_rule" "allow_build_agent_to_controller_nsg" {
#   depends_on = [
#     null_resource.initial_config
#   ]
#   name                        = "AllowBuildAgentHttpsInboundToController"
#   priority                    = 101
#   direction                   = "Inbound"
#   access                      = "Allow"
#   protocol                    = "*"
#   source_port_range           = "*"
#   destination_port_range      = "*"
#   source_address_prefix       = var.build_agent_ip_address
#   destination_address_prefix  = "*"
#   resource_group_name         = azurerm_resource_group.resource_group.name
#   network_security_group_name = azurerm_network_security_group.controller_security_group.name
# }

resource "azurerm_subnet_network_security_group_association" "azure_controller_nsg_association" {
  subnet_id                 = var.controller_subnet_id
  network_security_group_id = azurerm_network_security_group.controller_security_group.id
}


