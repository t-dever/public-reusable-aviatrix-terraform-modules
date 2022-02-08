data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "azure_transit_resource_group" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "azure_transit_vnet" {
  name                = var.vnet_name
  location            = azurerm_resource_group.azure_transit_resource_group.location
  resource_group_name = azurerm_resource_group.azure_transit_resource_group.name
  address_space       = [var.vnet_address_prefix]
}

resource "azurerm_subnet" "transit_gw_subnet" {
  count                = var.insane_mode ? 0 : 1
  name                 = "transit-gateway-mgmt-subnet"
  virtual_network_name = azurerm_virtual_network.azure_transit_vnet.name
  resource_group_name  = azurerm_resource_group.azure_transit_resource_group.name
  address_prefixes     = [local.transit_gateway_subnet]
}

resource "azurerm_subnet" "transit_gw_ha_subnet" {
  count                = var.transit_gateway_ha && var.insane_mode ? 0 : var.transit_gateway_ha ? 1 : 0
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

resource "azurerm_network_security_group" "firewall_mgmt_nsg" {
  count               = var.firenet_enabled ? 1 : 0
  name                = "${azurerm_subnet.azure_transit_firewall_subnet[0].name}-nsg"
  location            = azurerm_resource_group.azure_transit_resource_group.location
  resource_group_name = azurerm_resource_group.azure_transit_resource_group.name
}

resource "azurerm_network_security_rule" "allow_user_and_controller_inbound_to_firewall_mgmt" {
  count                       = var.firenet_enabled ? 1 : 0
  name                        = "allowUserAndControllerInboundToFirewall"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefixes     = concat(var.allowed_public_ips, [var.controller_public_ip])
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.azure_transit_resource_group.name
  network_security_group_name = azurerm_network_security_group.firewall_mgmt_nsg[0].name
}

resource "azurerm_subnet_network_security_group_association" "firewall_mgmt_nsg_association" {
  count                     = var.firenet_enabled ? 1 : 0
  subnet_id                 = azurerm_subnet.azure_transit_firewall_subnet[0].id
  network_security_group_id = azurerm_network_security_group.firewall_mgmt_nsg[0].id
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
  vpc_reg                          = var.location
  gw_size                          = var.transit_gw_size
  subnet                           = var.insane_mode ? local.transit_gateway_subnet : azurerm_subnet.transit_gw_subnet[0].address_prefixes[0]
  allocate_new_eip                 = false
  eip                              = azurerm_public_ip.transit_public_ip.ip_address
  azure_eip_name_resource_group    = "${azurerm_public_ip.transit_public_ip.name}:${azurerm_virtual_network.azure_transit_vnet.resource_group_name}"
  zone                             = var.transit_gateway_az_zone
  ha_subnet                        = var.transit_gateway_ha && var.insane_mode ? local.transit_gateway_ha_subnet : var.transit_gateway_ha ? azurerm_subnet.transit_gw_ha_subnet[0].address_prefixes[0] : null
  ha_zone                          = var.transit_gateway_ha ? var.transit_gateway_ha_az_zone : null
  ha_gw_size                       = var.transit_gateway_ha ? var.transit_gw_size : null
  ha_eip                           = var.transit_gateway_ha ? azurerm_public_ip.transit_hagw_public_ip[0].ip_address : null
  ha_azure_eip_name_resource_group = var.transit_gateway_ha ? "${azurerm_public_ip.transit_hagw_public_ip[0].name}:${azurerm_virtual_network.azure_transit_vnet.resource_group_name}" : null
  connected_transit                = true
  enable_advertise_transit_cidr    = true
  enable_segmentation              = true
  enable_transit_firenet           = var.firenet_enabled ? true : false
  enable_vpc_dns_server            = false
  insane_mode                      = var.insane_mode ? true : false
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

resource "azurerm_dev_test_global_vm_shutdown_schedule" "transit_shutdown_1" {
  count = var.enable_transit_gateway_scheduled_shutdown && var.transit_gateway_ha ? 1 : 0
  depends_on = [
    aviatrix_transit_gateway.azure_transit_gateway
  ]
  virtual_machine_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${azurerm_resource_group.azure_transit_resource_group.name}/providers/Microsoft.Compute/virtualMachines/av-gw-${var.transit_gateway_name}-hagw"
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
  value        = random_password.generate_firewall_secret[0].result
  key_vault_id = var.key_vault_id
}

resource "aviatrix_firenet" "firenet" {
  count                                = var.firenet_enabled ? 1 : 0
  vpc_id                               = data.aviatrix_transit_gateway.transit_gw_data.vpc_id
  inspection_enabled                   = true
  egress_enabled                       = var.egress_enabled
  keep_alive_via_lan_interface_enabled = false
  manage_firewall_instance_association = false
  east_west_inspection_excluded_cidrs  = []
  egress_static_cidrs                  = []
}

# LIMITATION: In firewall deployment we can't perform a count "x" due to the arm template deployment using the same deployment name
#             This will cause a failure when attempting to deploy 2 or more instances at the same time. TODO: (Potentially look into creating scale set for autoscaling capabilities)

data "aviatrix_transit_gateway" "transit_gw_data" {
  gw_name = aviatrix_transit_gateway.azure_transit_gateway.gw_name
}

resource "aviatrix_firewall_instance" "firewall_instance_1" {
  count                  = var.firenet_enabled ? 1 : 0
  vpc_id                 = data.aviatrix_transit_gateway.transit_gw_data.vpc_id
  firenet_gw_name        = aviatrix_transit_gateway.azure_transit_gateway.gw_name
  firewall_name          = "${var.firewall_name}-1"
  firewall_image         = var.firewall_image
  firewall_image_version = var.firewall_image_version
  firewall_size          = var.fw_instance_size
  zone                   = "az-1"
  username               = local.is_checkpoint ? "admin" : var.firewall_username
  password               = random_password.generate_firewall_secret[0].result
  management_subnet      = local.is_palo ? azurerm_subnet.transit_gw_subnet[0].address_prefix : null
  egress_subnet          = azurerm_subnet.azure_transit_firewall_subnet[0].address_prefix
  user_data              = local.is_fortinet ? local.fortinet_bootstrap : null
}

resource "aviatrix_firewall_instance" "firewall_instance_2" {
  count = var.firenet_enabled && var.firewall_ha ? 1 : 0
  depends_on = [
    aviatrix_firewall_instance.firewall_instance_1
  ]
  vpc_id                 = data.aviatrix_transit_gateway.transit_gw_data.vpc_id
  firenet_gw_name        = aviatrix_transit_gateway.azure_transit_gateway.gw_name
  firewall_name          = "${var.firewall_name}-2"
  firewall_image         = var.firewall_image
  firewall_image_version = var.firewall_image_version
  firewall_size          = var.fw_instance_size
  zone                   = "az-2"
  username               = local.is_checkpoint ? "admin" : var.firewall_username
  password               = random_password.generate_firewall_secret[0].result
  management_subnet      = local.is_palo ? azurerm_subnet.transit_gw_subnet[0].address_prefix : null
  egress_subnet          = azurerm_subnet.azure_transit_firewall_subnet[0].address_prefix
  user_data              = local.is_fortinet ? local.fortinet_bootstrap : null
}

resource "aviatrix_firewall_instance_association" "firewall_instance_association_1" {
  depends_on = [
    data.aviatrix_transit_gateway.transit_gw_data
  ]
  count                = var.firenet_enabled ? 1 : 0
  vpc_id               = aviatrix_firewall_instance.firewall_instance_1[0].vpc_id
  firenet_gw_name      = data.aviatrix_transit_gateway.transit_gw_data.gw_name
  instance_id          = aviatrix_firewall_instance.firewall_instance_1[0].instance_id
  firewall_name        = aviatrix_firewall_instance.firewall_instance_1[0].firewall_name
  lan_interface        = aviatrix_firewall_instance.firewall_instance_1[0].lan_interface
  management_interface = aviatrix_firewall_instance.firewall_instance_1[0].management_interface
  egress_interface     = aviatrix_firewall_instance.firewall_instance_1[0].egress_interface
  attached             = true
}

resource "aviatrix_firewall_instance_association" "firewall_instance_association_2" {
  depends_on = [
    data.aviatrix_transit_gateway.transit_gw_data
  ]
  count                = var.firenet_enabled && var.firewall_ha ? 1 : 0
  vpc_id               = aviatrix_firewall_instance.firewall_instance_2[0].vpc_id
  firenet_gw_name      = data.aviatrix_transit_gateway.transit_gw_data.gw_name
  instance_id          = aviatrix_firewall_instance.firewall_instance_2[0].instance_id
  firewall_name        = aviatrix_firewall_instance.firewall_instance_2[0].firewall_name
  lan_interface        = aviatrix_firewall_instance.firewall_instance_2[0].lan_interface
  management_interface = aviatrix_firewall_instance.firewall_instance_2[0].management_interface
  egress_interface     = aviatrix_firewall_instance.firewall_instance_2[0].egress_interface
  attached             = true
}

# Bootstrap configuration if firewall is fortinet
data "external" "fortinet_bootstrap_1" {
  count = var.firenet_enabled && local.is_fortinet ? 1 : 0
  depends_on = [
    aviatrix_firewall_instance.firewall_instance_1,
    aviatrix_firenet.firenet,
    aviatrix_firewall_instance_association.firewall_instance_association_1
  ]
  program = ["python", "${path.root}/firewalls/fortinet/generate_api_token.py"]
  query = {
    fortigate_hostname = "${aviatrix_firewall_instance.firewall_instance_1[0].public_ip}"
    fortigate_username = "${var.firewall_username}"
    fortigate_password = "${random_password.generate_firewall_secret[0].result}"
  }
}

# data "external" "fortinet_bootstrap_2" {
#   count = var.firenet_enabled && local.is_fortinet && var.firewall_ha ? 1 : 0
#   depends_on = [
#     aviatrix_firewall_instance.firewall_instance_2,
#     aviatrix_firenet.firenet,
#     aviatrix_firewall_instance_association.firewall_instance_association_2
#   ]
#   program = ["python", "${path.root}/firewalls/fortinet/generate_api_token.py"]
#   query = {
#     fortigate_hostname = "${aviatrix_firewall_instance.firewall_instance_2[0].public_ip}"
#     fortigate_username = "${var.firewall_username}"
#     fortigate_password = "${random_password.generate_firewall_secret[0].result}"
#   }
# }

# Vendor Integration if firewall vendor is fortinet.
# tflint-ignore: terraform_unused_declarations
# data "aviatrix_firenet_vendor_integration" "vendor_integration_1" {
#   count         = var.firenet_enabled && local.is_fortinet ? 1 : 0
#   vpc_id        = aviatrix_firewall_instance.firewall_instance_1[0].vpc_id
#   instance_id   = aviatrix_firewall_instance.firewall_instance_1[0].instance_id
#   vendor_type   = "Fortinet FortiGate"
#   public_ip     = aviatrix_firewall_instance.firewall_instance_1[0].public_ip
#   firewall_name = aviatrix_firewall_instance.firewall_instance_1[0].firewall_name
#   api_token     = sensitive(data.external.fortinet_bootstrap_1[0].result.api_key)
#   save          = true
# }

# # tflint-ignore: terraform_unused_declarations
# data "aviatrix_firenet_vendor_integration" "vendor_integration_2" {
#   count         = var.firenet_enabled && local.is_fortinet && var.firewall_ha ? 1 : 0
#   vpc_id        = aviatrix_firewall_instance.firewall_instance_2[0].vpc_id
#   instance_id   = aviatrix_firewall_instance.firewall_instance_2[0].instance_id
#   vendor_type   = "Fortinet FortiGate"
#   public_ip     = aviatrix_firewall_instance.firewall_instance_2[0].public_ip
#   firewall_name = aviatrix_firewall_instance.firewall_instance_2[0].firewall_name
#   api_token     = sensitive(data.external.fortinet_bootstrap_2[0].result.api_key)
#   save          = true
# }

output "name" {
  value = data.external.fortinet_bootstrap_1[0].result.api_key
}