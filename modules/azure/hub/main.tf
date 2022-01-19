locals {
  gateway_name  = "${var.resource_prefix}-transit-gw-vm"
  firewall_name = "${var.resource_prefix}-fw-vm"
}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "azure_hub_resource_group" {
  name     = "${var.resource_prefix}-rg"
  location = var.location
}

resource "azurerm_storage_account" "storage_account" {
  #checkov:skip=CKV_AZURE_35:The network rules are configured in a separate resource below
  name                      = replace("${var.resource_prefix}sa", "-", "")
  resource_group_name       = azurerm_resource_group.azure_hub_resource_group.name
  location                  = var.location
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  min_tls_version           = "TLS1_2"
  allow_blob_public_access  = false
  enable_https_traffic_only = true
}

resource "azurerm_storage_account_network_rules" "storage_account_access_rules" {
  storage_account_id = azurerm_storage_account.storage_account.id
  default_action     = "Deny"
  bypass             = ["AzureServices"]
  virtual_network_subnet_ids = [
    azurerm_subnet.azure_hub_gateway_subnet.id
  ]
}

resource "azurerm_virtual_network" "azure_hub_vnet" {
  name                = "${var.resource_prefix}-vnet"
  location            = var.location
  resource_group_name = azurerm_resource_group.azure_hub_resource_group.name
  address_space       = [var.vnet_address_prefix]
}

resource "azurerm_subnet" "azure_hub_gateway_subnet" {
  depends_on = [
    azurerm_virtual_network.azure_hub_vnet
  ]
  name                 = "gateway-subnet"
  virtual_network_name = "${var.resource_prefix}-vnet"
  resource_group_name  = azurerm_resource_group.azure_hub_resource_group.name
  address_prefixes     = [var.gateway_mgmt_subnet_address_prefix]
  service_endpoints    = ["Microsoft.Storage"]
}

resource "azurerm_subnet" "azure_hub_firewall_subnet" {
  count = var.firenet_enabled ? 1 : 0
  depends_on = [
    azurerm_virtual_network.azure_hub_vnet
  ]
  name                 = "firewall-ingress-egress"
  virtual_network_name = "${var.resource_prefix}-vnet"
  resource_group_name  = azurerm_resource_group.azure_hub_resource_group.name
  address_prefixes     = [var.firewall_ingress_egress_prefix]
}

resource "azurerm_public_ip" "azure_gateway_public_ip" {
  lifecycle {
    ignore_changes = [tags]
  }
  name                    = "${local.gateway_name}-public-ip"
  location                = var.location
  resource_group_name     = azurerm_resource_group.azure_hub_resource_group.name
  sku                     = "Standard"
  allocation_method       = "Static"
  idle_timeout_in_minutes = 4
}

# Create an Aviatrix Azure Transit Network Gateway
resource "aviatrix_transit_gateway" "azure_transit_gateway" {
  depends_on = [
    azurerm_public_ip.azure_gateway_public_ip
  ]
  lifecycle {
    ignore_changes = [tags]
  }
  cloud_type                    = 8
  account_name                  = var.aviatrix_azure_account
  gw_name                       = local.gateway_name
  vpc_id                        = "${azurerm_virtual_network.azure_hub_vnet.name}:${azurerm_virtual_network.azure_hub_vnet.resource_group_name}"
  vpc_reg                       = var.location
  gw_size                       = "Standard_B2ms"
  subnet                        = azurerm_subnet.azure_hub_gateway_subnet.address_prefix
  connected_transit             = true
  allocate_new_eip              = false
  eip                           = azurerm_public_ip.azure_gateway_public_ip.ip_address
  azure_eip_name_resource_group = "${azurerm_public_ip.azure_gateway_public_ip.name}:${azurerm_virtual_network.azure_hub_vnet.resource_group_name}"
  enable_advertise_transit_cidr = true
  enable_segmentation           = true
  enable_transit_firenet        = var.firenet_enabled ? true : false
  enable_vpc_dns_server         = false
  enable_active_mesh            = true
}

resource "azurerm_dev_test_global_vm_shutdown_schedule" "transit_shutdown" {
  depends_on = [
    aviatrix_transit_gateway.azure_transit_gateway
  ]
  virtual_machine_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${azurerm_resource_group.azure_hub_resource_group.name}/providers/Microsoft.Compute/virtualMachines/av-gw-${local.gateway_name}"
  location           = azurerm_resource_group.azure_hub_resource_group.location
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
  name         = "${local.firewall_name}-secret"
  value        = random_password.generate_firewall_secret[count.index].result
  key_vault_id = var.key_vault_id
}

resource "aviatrix_firewall_instance" "firewall_instance" {
  count = var.firenet_enabled ? 1 : 0
  depends_on = [
    aviatrix_transit_gateway.azure_transit_gateway
  ]
  vpc_id                 = aviatrix_transit_gateway.azure_transit_gateway.vpc_id
  firenet_gw_name        = aviatrix_transit_gateway.azure_transit_gateway.gw_name
  firewall_name          = local.firewall_name
  firewall_image         = var.firewall_image
  firewall_image_version = var.firewall_image_version
  firewall_size          = var.fw_instance_size
  username               = local.is_checkpoint ? "admin" : var.firewall_username
  password               = random_password.generate_firewall_secret[count.index].result
  management_subnet      = local.is_palo ? azurerm_subnet.azure_hub_gateway_subnet.address_prefix : null
  egress_subnet          = azurerm_subnet.azure_hub_firewall_subnet[count.index].address_prefix
  user_data = file("fortinet_init.conf")
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

data "external" "example" {
  program = ["python", "${path.root}/firewalls/fortinet/generate_api_token.py"]
  # environment = {
  #   FORTIGATE_HOSTNAME = aviatrix_firewall_instance.firewall_instance[0].public_ip
  #   FORTIGATE_USERNAME = var.firewall_username
  #   FORTIGATE_PASSWORD = random_password.generate_firewall_secret[0].result
  # }
  query = {
    # arbitrary map from strings to strings, passed
    # to the external program as the data query.
    -fortigate_hostname = aviatrix_firewall_instance.firewall_instance[0].public_ip
    -fortigate_username = var.firewall_username
    -fortigate_password = random_password.generate_firewall_secret[0].result
  }
}

# resource "null_resource" "test_null_resource" {
#   # Bootstrap script can run on any instance of the cluster
#   # So we just choose the first in this case
#   connection {
#     type     = "ssh"
#     user     = var.firewall_username
#     password = random_password.generate_firewall_secret[0].result
#     host     = aviatrix_firewall_instance.firewall_instance[0].public_ip
#   }

#   provisioner "remote-exec" {
#     # Bootstrap script called with private_ip of each node in the clutser
#     command = "execute api-user generate-key test1"
#   }
# }



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

# data "aviatrix_firenet_vendor_integration" "vendor_integration" {
#   count         = var.firenet_enabled ? 1 : 0
#   vpc_id        = aviatrix_firewall_instance.palo_firewall_instance[count.index].vpc_id
#   instance_id   = aviatrix_firewall_instance.palo_firewall_instance[count.index].instance_id
#   vendor_type   = "Palo Alto Networks VM-Series"
#   public_ip     = aviatrix_firewall_instance.palo_firewall_instance[count.index].public_ip
#   username      = "paloAdmin"
#   password      = random_password.generate_firewall_secret[count.index].result
#   firewall_name = local.firewall_name
#   save          = true
# }

# Creates scheduled shutdown of VM for 6 p.m. CST
# resource "azurerm_dev_test_global_vm_shutdown_schedule" "vm_shutdown_schedule" {
#   lifecycle {
#     ignore_changes = [tags]
#   }
#   for_each           = { for index, id in data.azurerm_resources.virtual_machines.resources : index => id }
#   virtual_machine_id = each.value.id
#   location           = var.location
#   enabled            = true

#   daily_recurrence_time = "1800"
#   timezone              = "Central Standard Time"
#   notification_settings {
#     enabled = false
#   }
# }
