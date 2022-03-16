resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_address_space
  tags       = { "Name" = var.vpc_name }
}

resource "aws_default_security_group" "default_security_group" {
  vpc_id = aws_vpc.vpc.id
}

variable "vpc_name" {
  description = "The name of the VPC."
  type        = string
  default     = "aviatrix-transit-vpc"
}

resource "aws_subnet" "aviatrix_transit_primary_subnet" {
  count             = var.insane_mode ? 0 : 1
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = local.transit_gateway_subnet
  availability_zone = length(var.aviatrix_transit_availability_zone_1) > 0 ? var.aviatrix_transit_availability_zone_1 : "${var.region}a"
  tags              = { "Name" = "${var.aviatrix_transit_primary_subnet_name}" }
}

resource "aws_subnet" "aviatrix_transit_ha_subnet" {
  count             = var.insane_mode ? 0 : var.enable_aviatrix_transit_gateway_ha ? 1 : 0
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = local.transit_gateway_ha_subnet
  availability_zone = length(var.aviatrix_transit_availability_zone_2) > 0 ? var.aviatrix_transit_availability_zone_2 : "${var.region}b"
  tags              = { "Name" = "${var.aviatrix_transit_primary_subnet_name}" }
}

# Creates Internet Gateway for VPC
resource "aws_internet_gateway" "vpc_internet_gateway" {
  vpc_id = aws_vpc.vpc.id
  tags   = { "Name" = "${var.tag_prefix}-internet-gateway" }
}

# Creates Route Table for VPC
resource "aws_route_table" "vpc_route_table" {
  vpc_id = aws_vpc.vpc.id
  tags   = { "Name" = "${var.tag_prefix}-route-table" }
}

# Creates Default Route to Internet for route table.
resource "aws_route" "internet_route" {
  route_table_id         = aws_route_table.vpc_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.vpc_internet_gateway.id
}

# Associate Route Table to Aviatrix Transit Primary Subnet
resource "aws_route_table_association" "aviatrix_transit_primary_route_table_assoc" {
  count          = var.insane_mode ? 0 : var.enable_aviatrix_transit_gateway_ha ? 1 : 0
  subnet_id      = aws_subnet.aviatrix_transit_primary_subnet[0].id
  route_table_id = aws_route_table.vpc_route_table.id
}

# Associate Route Table to Aviatrix Transit HA Subnet
resource "aws_route_table_association" "aviatrix_transit_ha_route_table_assoc" {
  count          = var.insane_mode ? 0 : var.enable_aviatrix_transit_gateway_ha ? 1 : 0
  subnet_id      = aws_subnet.aviatrix_transit_ha_subnet[0].id
  route_table_id = aws_route_table.vpc_route_table.id
}

# Deploy Aviatrix Transit Gateways
resource "aviatrix_transit_gateway" "aviatrix_transit_gateway" {
  lifecycle {
    ignore_changes = [tags]
  }
  cloud_type                    = local.is_aws_gov ? 256 : 1
  account_name                  = var.aviatrix_access_account_name
  gw_name                       = var.aviatrix_transit_gateway_name
  vpc_id                        = aws_vpc.vpc.id
  vpc_reg                       = var.region
  gw_size                       = var.aviatrix_transit_gateway_size
  subnet                        = local.transit_gateway_subnet
  ha_subnet                     = var.enable_aviatrix_transit_gateway_ha ? local.transit_gateway_ha_subnet : null
  allocate_new_eip              = true
  ha_gw_size                    = var.enable_aviatrix_transit_gateway_ha ? var.aviatrix_transit_gateway_size : null
  connected_transit             = true
  enable_advertise_transit_cidr = true
  enable_segmentation           = true
  enable_transit_firenet        = var.enable_aviatrix_transit_firenet ? true : false
  enable_hybrid_connection      = true
  enable_vpc_dns_server         = false
  insane_mode                   = var.insane_mode ? true : false
  insane_mode_az                = var.insane_mode ? length(var.aviatrix_transit_availability_zone_1) > 0 ? var.aviatrix_transit_availability_zone_1 : "${var.region}a" : null
  ha_insane_mode_az             = var.enable_aviatrix_transit_gateway_ha && var.insane_mode ? length(var.aviatrix_transit_availability_zone_2) > 0 ? var.aviatrix_transit_availability_zone_2 : "${var.region}b" : null
  enable_gateway_load_balancer = true
}

# resource "azurerm_subnet" "azure_transit_firewall_subnet" {
#   count                = var.firenet_enabled ? 1 : 0
#   name                 = "firewall-subnet"
#   virtual_network_name = azurerm_virtual_network.azure_transit_vnet.name
#   resource_group_name  = azurerm_resource_group.azure_transit_resource_group.name
#   address_prefixes     = [local.firewall_subnet]
# }

# resource "azurerm_network_security_group" "firewall_mgmt_nsg" {
#   count               = var.firenet_enabled ? 1 : 0
#   name                = "${azurerm_subnet.azure_transit_firewall_subnet[0].name}-nsg"
#   location            = azurerm_resource_group.azure_transit_resource_group.location
#   resource_group_name = azurerm_resource_group.azure_transit_resource_group.name
# }

# resource "azurerm_network_security_rule" "allow_user_and_controller_inbound_to_firewall_mgmt" {
#   count                       = var.firenet_enabled ? 1 : 0
#   name                        = "allowUserAndControllerInboundToFirewall"
#   priority                    = 100
#   direction                   = "Inbound"
#   access                      = "Allow"
#   protocol                    = "*"
#   source_port_range           = "*"
#   destination_port_range      = "*"
#   source_address_prefixes     = concat(var.allowed_public_ips, [var.controller_public_ip])
#   destination_address_prefix  = "*"
#   resource_group_name         = azurerm_resource_group.azure_transit_resource_group.name
#   network_security_group_name = azurerm_network_security_group.firewall_mgmt_nsg[0].name
# }

# resource "azurerm_subnet_network_security_group_association" "firewall_mgmt_nsg_association" {
#   count                     = var.firenet_enabled ? 1 : 0
#   subnet_id                 = azurerm_subnet.azure_transit_firewall_subnet[0].id
#   network_security_group_id = azurerm_network_security_group.firewall_mgmt_nsg[0].id
# }

# resource "azurerm_public_ip" "transit_public_ip" {
#   lifecycle {
#     ignore_changes = [tags]
#   }
#   name                = "${var.transit_gateway_name}-public-ip"
#   location            = azurerm_resource_group.azure_transit_resource_group.location
#   resource_group_name = azurerm_resource_group.azure_transit_resource_group.name
#   sku                 = "Standard"
#   allocation_method   = "Static"
# }

# resource "azurerm_public_ip" "transit_hagw_public_ip" {
#   lifecycle {
#     ignore_changes = [tags]
#   }
#   count               = var.transit_gateway_ha ? 1 : 0
#   name                = "${var.transit_gateway_name}-ha-public-ip"
#   location            = azurerm_resource_group.azure_transit_resource_group.location
#   resource_group_name = azurerm_resource_group.azure_transit_resource_group.name
#   sku                 = "Standard"
#   allocation_method   = "Static"
# }

# # Create an Aviatrix Azure Transit Network Gateway


# resource "azurerm_dev_test_global_vm_shutdown_schedule" "transit_shutdown" {
#   count = var.enable_transit_gateway_scheduled_shutdown ? 1 : 0
#   depends_on = [
#     aviatrix_transit_gateway.azure_transit_gateway
#   ]
#   virtual_machine_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${azurerm_resource_group.azure_transit_resource_group.name}/providers/Microsoft.Compute/virtualMachines/av-gw-${var.transit_gateway_name}"
#   location           = azurerm_resource_group.azure_transit_resource_group.location
#   enabled            = true

#   daily_recurrence_time = "1800"
#   timezone              = "Central Standard Time"
#   notification_settings {
#     enabled = false
#   }
# }

# resource "azurerm_dev_test_global_vm_shutdown_schedule" "transit_shutdown_1" {
#   count = var.enable_transit_gateway_scheduled_shutdown && var.transit_gateway_ha ? 1 : 0
#   depends_on = [
#     aviatrix_transit_gateway.azure_transit_gateway
#   ]
#   virtual_machine_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${azurerm_resource_group.azure_transit_resource_group.name}/providers/Microsoft.Compute/virtualMachines/av-gw-${var.transit_gateway_name}-hagw"
#   location           = azurerm_resource_group.azure_transit_resource_group.location
#   enabled            = true

#   daily_recurrence_time = "1800"
#   timezone              = "Central Standard Time"
#   notification_settings {
#     enabled = false
#   }
# }

# resource "random_password" "generate_firewall_secret" {
#   count            = var.firenet_enabled ? 1 : 0
#   length           = 16
#   special          = true
#   override_special = "_%@"
# }

# resource "azurerm_key_vault_secret" "firewall_secret" {
#   count        = var.firenet_enabled ? 1 : 0
#   name         = "${var.firewall_name}-secret"
#   value        = random_password.generate_firewall_secret[0].result
#   key_vault_id = var.key_vault_id
# }

# resource "aviatrix_firenet" "firenet" {
#   count                                = var.firenet_enabled ? 1 : 0
#   vpc_id                               = data.aviatrix_transit_gateway.transit_gw_data.vpc_id
#   inspection_enabled                   = true
#   egress_enabled                       = var.egress_enabled
#   keep_alive_via_lan_interface_enabled = false
#   manage_firewall_instance_association = false
#   east_west_inspection_excluded_cidrs  = []
#   egress_static_cidrs                  = []
# }

# # LIMITATION: In firewall deployment we can't perform a count "x" due to the arm template deployment using the same deployment name
# #             This will cause a failure when attempting to deploy 2 or more instances at the same time. TODO: (Potentially look into creating scale set for autoscaling capabilities)

# data "aviatrix_transit_gateway" "transit_gw_data" {
#   gw_name = aviatrix_transit_gateway.azure_transit_gateway.gw_name
# }

# resource "aviatrix_firewall_instance" "firewall_instance_1" {
#   count                  = var.firenet_enabled ? 1 : 0
#   vpc_id                 = data.aviatrix_transit_gateway.transit_gw_data.vpc_id
#   firenet_gw_name        = aviatrix_transit_gateway.azure_transit_gateway.gw_name
#   firewall_name          = "${var.firewall_name}-1"
#   firewall_image         = var.firewall_image
#   firewall_image_version = var.firewall_image_version
#   firewall_size          = var.fw_instance_size
#   zone                   = "az-1"
#   username               = local.is_checkpoint ? "admin" : var.firewall_username
#   password               = random_password.generate_firewall_secret[0].result
#   management_subnet      = local.is_palo ? azurerm_subnet.transit_gw_subnet[0].address_prefix : null
#   egress_subnet          = azurerm_subnet.azure_transit_firewall_subnet[0].address_prefix
#   user_data              = local.is_fortinet ? local.fortinet_bootstrap : null
# }

# resource "aviatrix_firewall_instance" "firewall_instance_2" {
#   count = var.firenet_enabled && var.firewall_ha ? 1 : 0
#   depends_on = [
#     aviatrix_firewall_instance.firewall_instance_1
#   ]
#   vpc_id                 = data.aviatrix_transit_gateway.transit_gw_data.vpc_id
#   firenet_gw_name        = aviatrix_transit_gateway.azure_transit_gateway.gw_name
#   firewall_name          = "${var.firewall_name}-2"
#   firewall_image         = var.firewall_image
#   firewall_image_version = var.firewall_image_version
#   firewall_size          = var.fw_instance_size
#   zone                   = "az-2"
#   username               = local.is_checkpoint ? "admin" : var.firewall_username
#   password               = random_password.generate_firewall_secret[0].result
#   management_subnet      = local.is_palo ? azurerm_subnet.transit_gw_subnet[0].address_prefix : null
#   egress_subnet          = azurerm_subnet.azure_transit_firewall_subnet[0].address_prefix
#   user_data              = local.is_fortinet ? local.fortinet_bootstrap : null
# }

# resource "aviatrix_firewall_instance_association" "firewall_instance_association_1" {
#   depends_on = [
#     data.aviatrix_transit_gateway.transit_gw_data
#   ]
#   count                = var.firenet_enabled ? 1 : 0
#   vpc_id               = aviatrix_firewall_instance.firewall_instance_1[0].vpc_id
#   firenet_gw_name      = data.aviatrix_transit_gateway.transit_gw_data.gw_name
#   instance_id          = aviatrix_firewall_instance.firewall_instance_1[0].instance_id
#   firewall_name        = aviatrix_firewall_instance.firewall_instance_1[0].firewall_name
#   lan_interface        = aviatrix_firewall_instance.firewall_instance_1[0].lan_interface
#   management_interface = aviatrix_firewall_instance.firewall_instance_1[0].management_interface
#   egress_interface     = aviatrix_firewall_instance.firewall_instance_1[0].egress_interface
#   attached             = true
# }

# resource "aviatrix_firewall_instance_association" "firewall_instance_association_2" {
#   depends_on = [
#     data.aviatrix_transit_gateway.transit_gw_data
#   ]
#   count                = var.firenet_enabled && var.firewall_ha ? 1 : 0
#   vpc_id               = aviatrix_firewall_instance.firewall_instance_2[0].vpc_id
#   firenet_gw_name      = data.aviatrix_transit_gateway.transit_gw_data.gw_name
#   instance_id          = aviatrix_firewall_instance.firewall_instance_2[0].instance_id
#   firewall_name        = aviatrix_firewall_instance.firewall_instance_2[0].firewall_name
#   lan_interface        = aviatrix_firewall_instance.firewall_instance_2[0].lan_interface
#   management_interface = aviatrix_firewall_instance.firewall_instance_2[0].management_interface
#   egress_interface     = aviatrix_firewall_instance.firewall_instance_2[0].egress_interface
#   attached             = true
# }

# # Bootstrap configuration if firewall is fortinet
# data "external" "fortinet_bootstrap_1" {
#   count = var.firenet_enabled && local.is_fortinet ? 1 : 0
#   depends_on = [
#     aviatrix_firewall_instance.firewall_instance_1,
#     aviatrix_firenet.firenet,
#     aviatrix_firewall_instance_association.firewall_instance_association_1
#   ]
#   program = ["python", "${path.root}/firewalls/fortinet/generate_api_token.py"]
#   query = {
#     fortigate_hostname = "${aviatrix_firewall_instance.firewall_instance_1[0].public_ip}"
#     fortigate_username = "${var.firewall_username}"
#     fortigate_password = "${random_password.generate_firewall_secret[0].result}"
#   }
# }

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

# # tflint-ignore: terraform_unused_declarations
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
