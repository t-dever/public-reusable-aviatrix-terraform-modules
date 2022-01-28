data "azurerm_client_config" "current" {}

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
  account_name                     = var.enable_security_group_management ? var.azure_account_name : null
  enable_security_group_management = var.enable_security_group_management ? true : false
}

data "azurerm_network_security_group" "controller_security_group" {
  depends_on = [
    aviatrix_controller_security_group_management_config.security_group_management
  ]
  name                = "Aviatrix-SG-${var.controller_public_ip}" # GROSSS, I have to do this because I can't reference it as an attribute.
  resource_group_name = var.resource_group_name
}

resource "azurerm_network_security_rule" "allow_user_to_controller_nsg" {
  depends_on = [
    data.azurerm_network_security_group.controller_security_group,
    aviatrix_account.azure_account,
    aviatrix_controller_security_group_management_config.security_group_management
  ]
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
  network_security_group_name = data.azurerm_network_security_group.controller_security_group.name
}

resource "azurerm_network_security_rule" "allow_controller_inbound_to_copilot" {
  depends_on = [
    data.azurerm_network_security_group.controller_security_group
  ]
  count                       = var.copilot_private_ip != "" ? 1 : 0
  name                        = "AllowControllerInboundToCopilot"
  priority                    = 101
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = var.controller_public_ip
  destination_address_prefix  = var.copilot_private_ip
  resource_group_name         = var.resource_group_name
  network_security_group_name = data.azurerm_network_security_group.controller_security_group.name
}

resource "azurerm_network_security_rule" "allow_copilot_inbound_to_controller" {
  depends_on = [
    data.azurerm_network_security_group.controller_security_group
  ]
  count                       = var.copilot_public_ip != "" ? 1 : 0
  name                        = "AllowCoPilotInboundToController"
  priority                    = 102
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = var.copilot_public_ip
  destination_address_prefix  = var.controller_private_ip
  resource_group_name         = var.resource_group_name
  network_security_group_name = data.azurerm_network_security_group.controller_security_group.name
}

resource "azurerm_network_security_rule" "allow_netflow_inbound_to_copilot" {
  #checkov:skip=CKV_AZURE_77:Allow all internet UDP to copilot. May restrict this further in later updates.
  depends_on = [
    data.azurerm_network_security_group.controller_security_group,
  ]
  count                       = var.copilot_private_ip != "" ? 1 : 0
  name                        = "AllowNetflowInboundToCoPilot"
  priority                    = 103
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Udp"
  source_port_range           = "*"
  destination_port_ranges     = [var.netflow_port, var.rsyslog_port]
  source_address_prefix       = "*"
  destination_address_prefix  = var.copilot_private_ip
  resource_group_name         = var.resource_group_name
  network_security_group_name = data.azurerm_network_security_group.controller_security_group.name
}

resource "azurerm_subnet_network_security_group_association" "azure_controller_nsg_association" {
  depends_on = [
    aviatrix_account.azure_account,
    aviatrix_controller_security_group_management_config.security_group_management
  ]
  subnet_id                 = var.controller_subnet_id
  network_security_group_id = data.azurerm_network_security_group.controller_security_group.id
}

resource "aviatrix_copilot_association" "copilot_association" {
  copilot_address = var.copilot_public_ip
}

resource "aviatrix_netflow_agent" "netflow_agent" {
  count     = var.enable_netflow_to_copilot ? 1 : 0
  server_ip = var.copilot_public_ip
  port      = var.netflow_port
  version   = 9
}

resource "aviatrix_remote_syslog" "remote_syslog" {
  count    = var.enable_rsyslog_to_copilot ? 1 : 0
  index    = 0
  name     = "copilot"
  server   = var.copilot_public_ip
  port     = var.rsyslog_port
  protocol = var.rsyslog_protocol
}

resource "aviatrix_controller_config" "controller_backup" {
  depends_on = [
    aviatrix_account.azure_account
  ]
  count                 = var.enable_backup ? 1 : 0
  backup_configuration  = true
  backup_cloud_type     = 8
  backup_account_name   = var.azure_account_name
  backup_storage_name   = var.backup_storage_name
  backup_container_name = var.backup_container_name
  backup_region         = var.backup_region
  multiple_backups      = true
}