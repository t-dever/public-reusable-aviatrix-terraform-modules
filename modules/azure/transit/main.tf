data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "azure_transit_resource_group" {
  name     = var.resource_group_name
  location = var.location
}

# resource "azurerm_storage_account" "storage_account" {
#   #checkov:skip=CKV_AZURE_35:The network rules are configured in a separate resource below
#   name                      = var.storage_account_name
#   resource_group_name       = azurerm_resource_group.azure_transit_resource_group.name
#   location                  = azurerm_resource_group.azure_transit_resource_group.location
#   account_tier              = "Standard"
#   account_replication_type  = "LRS"
#   min_tls_version           = "TLS1_2"
#   allow_blob_public_access  = false
#   enable_https_traffic_only = true
# }

resource "azurerm_virtual_network" "azure_transit_vnet" {
  name                = var.vnet_name
  location            = azurerm_resource_group.azure_transit_resource_group.location
  resource_group_name = azurerm_resource_group.azure_transit_resource_group.name
  address_space       = [var.vnet_address_prefix]
}

resource "azurerm_subnet" "transit_gw_subnet" {
  name                 = "transit-gateway-mgmt-subnet"
  virtual_network_name = azurerm_virtual_network.azure_transit_vnet.name
  resource_group_name  = azurerm_resource_group.azure_transit_resource_group.name
  address_prefixes     = [local.transit_gateway_subnet]
}

resource "azurerm_subnet" "transit_gw_ha_subnet" {
  count                = var.transit_gateway_ha ? 1 : 0
  name                 = "transit-gateway-ha-mgmt-subnet"
  virtual_network_name = azurerm_virtual_network.azure_transit_vnet.name
  resource_group_name  = azurerm_resource_group.azure_transit_resource_group.name
  address_prefixes     = [local.transit_gateway_ha_subnet]
}

resource "azurerm_subnet" "azure_transit_firewall_subnet" {
  count                = var.firenet_enabled ? 1 : 0
  name                 = "firewall-subnet"
  virtual_network_name = azurerm_virtual_network.azure_transit_vnet.name
  resource_group_name  = azurerm_resource_group.azure_transit_resource_group.name
  address_prefixes     = [local.firewall_subnet]
}

resource "azurerm_public_ip" "transit_public_ip" {
  lifecycle {
    ignore_changes = [tags]
  }
  name                = "${var.transit_gateway_name}-public-ip"
  location            = azurerm_resource_group.azure_transit_resource_group.location
  resource_group_name = azurerm_resource_group.azure_transit_resource_group.name
  sku                 = "Standard"
  allocation_method   = "Static"
}

resource "azurerm_public_ip" "transit_hagw_public_ip" {
  lifecycle {
    ignore_changes = [tags]
  }
  count               = var.transit_gateway_ha ? 1 : 0
  name                = "${var.transit_gateway_name}-ha-public-ip"
  location            = azurerm_resource_group.azure_transit_resource_group.location
  resource_group_name = azurerm_resource_group.azure_transit_resource_group.name
  sku                 = "Standard"
  allocation_method   = "Static"
}


# Create an Aviatrix Azure Transit Network Gateway
resource "aviatrix_transit_gateway" "azure_transit_gateway" {
  depends_on = [
    azurerm_public_ip.transit_public_ip,
    azurerm_public_ip.transit_hagw_public_ip
  ]
  lifecycle {
    ignore_changes = [tags]
  }
  cloud_type                       = 8
  account_name                     = var.aviatrix_azure_account
  gw_name                          = var.transit_gateway_name
  vpc_id                           = "${azurerm_virtual_network.azure_transit_vnet.name}:${azurerm_virtual_network.azure_transit_vnet.resource_group_name}"
  vpc_reg                          = azurerm_resource_group.azure_transit_resource_group.location
  gw_size                          = var.transit_gw_size
  subnet                           = azurerm_subnet.transit_gw_subnet.address_prefixes[0]
  eip                              = azurerm_public_ip.transit_public_ip.ip_address
  azure_eip_name_resource_group    = "${azurerm_public_ip.transit_public_ip.name}:${azurerm_virtual_network.azure_transit_vnet.resource_group_name}"
  zone                             = "az-1"
  ha_subnet                        = var.transit_gateway_ha ? azurerm_subnet.transit_gw_ha_subnet[0].address_prefixes[0] : null
  ha_zone                          = var.transit_gateway_ha ? "az-2" : null
  ha_gw_size                       = var.transit_gateway_ha ? var.transit_gw_size : null
  ha_eip                           = var.transit_gateway_ha ? azurerm_public_ip.transit_hagw_public_ip[0].ip_address : null
  ha_azure_eip_name_resource_group = var.transit_gateway_ha ? "${azurerm_public_ip.transit_hagw_public_ip[0].name}:${azurerm_virtual_network.azure_transit_vnet.resource_group_name}" : null
  connected_transit                = true
  allocate_new_eip                 = false
  enable_advertise_transit_cidr    = true
  enable_segmentation              = true
  enable_transit_firenet           = var.firenet_enabled ? true : false
  enable_vpc_dns_server            = false
  enable_active_mesh               = true
}

data "aviatrix_transit_gateway" "transit_gw_data" {
  depends_on = [
    aviatrix_transit_gateway.azure_transit_gateway
  ]
  gw_name = aviatrix_transit_gateway.azure_transit_gateway.gw_name
}

resource "azurerm_dev_test_global_vm_shutdown_schedule" "transit_shutdown" {
  count = var.enable_transit_gateway_scheduled_shutdown ? 1 : 0
  depends_on = [
    aviatrix_transit_gateway.azure_transit_gateway
  ]
  virtual_machine_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${azurerm_resource_group.azure_transit_resource_group.name}/providers/Microsoft.Compute/virtualMachines/av-gw-${var.transit_gateway_name}"
  location           = azurerm_resource_group.azure_transit_resource_group.location
  enabled            = true

  daily_recurrence_time = "1800"
  timezone              = "Central Standard Time"
  notification_settings {
    enabled = false
  }
}

resource "random_password" "generate_firewall_secret" {
  count            = var.firenet_enabled ? 1 : 0
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "azurerm_key_vault_secret" "firewall_secret" {
  count        = var.firenet_enabled ? 1 : 0
  name         = "${var.firewall_name}-secret"
  value        = random_password.generate_firewall_secret[count.index].result
  key_vault_id = var.key_vault_id
}

resource "aviatrix_firewall_instance" "firewall_instance" {
  count = var.firenet_enabled ? 1 : 0
  depends_on = [
    aviatrix_transit_gateway.azure_transit_gateway
  ]
  vpc_id = data.aviatrix_transit_gateway.transit_gw_data.vpc_id
  # vpc_id                 = aviatrix_transit_gateway.azure_transit_gateway.vpc_id
  firenet_gw_name        = aviatrix_transit_gateway.azure_transit_gateway.gw_name
  firewall_name          = var.firewall_name
  firewall_image         = var.firewall_image
  firewall_image_version = var.firewall_image_version
  firewall_size          = var.fw_instance_size
  username               = local.is_checkpoint ? "admin" : var.firewall_username
  password               = random_password.generate_firewall_secret[count.index].result
  management_subnet      = local.is_palo ? azurerm_subnet.transit_gw_subnet.address_prefix : null
  egress_subnet          = azurerm_subnet.azure_transit_firewall_subnet[count.index].address_prefix
  user_data              = templatefile("${path.module}/firewalls/fortinet/fortinet_init.tftpl", { gateway = local.firewall_lan_subnet })
}

resource "aviatrix_firenet" "firenet" {
  count = var.firenet_enabled ? 1 : 0
  depends_on = [
    aviatrix_firewall_instance.firewall_instance
  ]
  vpc_id                               = aviatrix_firewall_instance.firewall_instance[count.index].vpc_id
  inspection_enabled                   = true
  egress_enabled                       = var.egress_enabled
  keep_alive_via_lan_interface_enabled = false
  manage_firewall_instance_association = false
  east_west_inspection_excluded_cidrs  = []
  egress_static_cidrs                  = []
}

resource "aviatrix_firewall_instance_association" "firewall_instance_association" {
  count = var.firenet_enabled ? 1 : 0
  depends_on = [
    aviatrix_firewall_instance.firewall_instance,
    aviatrix_transit_gateway.azure_transit_gateway
  ]
  vpc_id               = aviatrix_firewall_instance.firewall_instance[count.index].vpc_id
  firenet_gw_name      = aviatrix_transit_gateway.azure_transit_gateway.gw_name
  instance_id          = aviatrix_firewall_instance.firewall_instance[count.index].instance_id
  firewall_name        = aviatrix_firewall_instance.firewall_instance[count.index].firewall_name
  lan_interface        = aviatrix_firewall_instance.firewall_instance[count.index].lan_interface
  management_interface = aviatrix_firewall_instance.firewall_instance[count.index].management_interface
  egress_interface     = aviatrix_firewall_instance.firewall_instance[count.index].egress_interface
  attached             = true
}

data "external" "fortinet_bootstrap" {
  count = local.is_fortinet ? 1 : 0
  depends_on = [
    aviatrix_firewall_instance.firewall_instance,
    aviatrix_firenet.firenet,
    aviatrix_firewall_instance_association.firewall_instance_association
  ]
  program = ["python", "${path.root}/firewalls/fortinet/generate_api_token.py"]
  query = {
    fortigate_hostname = "${aviatrix_firewall_instance.firewall_instance[0].public_ip}"
    fortigate_username = "${var.firewall_username}"
    fortigate_password = "${random_password.generate_firewall_secret[0].result}"
  }
}

data "aviatrix_firenet_vendor_integration" "vendor_integration" {
  count         = var.firenet_enabled && local.is_fortinet ? 1 : 0 
  vpc_id        = aviatrix_firewall_instance.firewall_instance[count.index].vpc_id
  instance_id   = aviatrix_firewall_instance.firewall_instance[count.index].instance_id
  vendor_type   = "Fortinet FortiGate"
  public_ip     = aviatrix_firewall_instance.firewall_instance[count.index].public_ip
  firewall_name = var.firewall_name
  api_token     = sensitive(data.external.fortinet_bootstrap[count.index].result.api_key)
  save          = true
}

# # Modifies the existing mgmt NSG to only allow your user inbound to manage
# resource "azurerm_network_security_rule" "palo_allow_user_mgmt_nsg_inbound" {
#   count = var.firenet_enabled ? 1 : 0
#   depends_on = [
#     aviatrix_firewall_instance.palo_firewall_instance
#   ]
#   name                        = "AllowHttpsUserMgmtInbound"
#   priority                    = 100
#   direction                   = "Inbound"
#   access                      = "Allow"
#   protocol                    = "Tcp"
#   source_port_range           = "*"
#   destination_port_range      = "443"
#   source_address_prefix       = var.user_public_for_mgmt
#   destination_address_prefix  = "*"
#   resource_group_name         = azurerm_resource_group.azure_hub_resource_group.name
#   network_security_group_name = "${local.firewall_name}-management"
# }

# # # Allows Controller to access firewall mgmt
# resource "azurerm_network_security_rule" "palo_allow_controller_mgmt_nsg_inbound" {
#   count = var.firenet_enabled ? 1 : 0
#   depends_on = [
#     aviatrix_firewall_instance.palo_firewall_instance
#   ]
#   name                        = "AllowHttpsControllerMgmtInbound"
#   priority                    = 101
#   direction                   = "Inbound"
#   access                      = "Allow"
#   protocol                    = "*"
#   source_port_range           = "*"
#   destination_port_range      = "*"
#   source_address_prefix       = var.controller_public_ip
#   destination_address_prefix  = "*"
#   resource_group_name         = azurerm_resource_group.azure_hub_resource_group.name
#   network_security_group_name = "${local.firewall_name}-management"
# }

# # # Modifies the existing mgmt NSG to only allow your user inbound to manage
# resource "azurerm_network_security_rule" "palo_deny_mgmt_nsg_inbound" {
#   count = var.firenet_enabled ? 1 : 0
#   depends_on = [
#     aviatrix_firewall_instance.palo_firewall_instance
#   ]
#   name                        = "DenyAllInbound"
#   priority                    = 110
#   direction                   = "Inbound"
#   access                      = "Deny"
#   protocol                    = "*"
#   source_port_range           = "*"
#   destination_port_range      = "*"
#   source_address_prefix       = "*"
#   destination_address_prefix  = "*"
#   resource_group_name         = azurerm_resource_group.azure_hub_resource_group.name
#   network_security_group_name = "${local.firewall_name}-management"
# }
