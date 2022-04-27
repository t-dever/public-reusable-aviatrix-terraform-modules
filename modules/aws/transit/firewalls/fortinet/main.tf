# Creates Firewall Instance
resource "aviatrix_firewall_instance" "firewall_instance" {
  count                  = length(var.firewalls)
  vpc_id                 = var.aws_vpc_id
  firenet_gw_name        = count.index % 2 == 0 ? var.aviatrix_transit_primary_gateway_name : var.aviatrix_transit_ha_gateway_name
  firewall_name          = var.firewalls[count.index].name
  firewall_image         = var.firewall_image
  firewall_image_version = var.firewall_image_version
  firewall_size          = var.firewall_size
  management_subnet      = count.index % 2 == 0 ? var.firewall_mgmt_primary_subnet : var.firewall_mgmt_ha_subnet
  egress_subnet          = count.index % 2 == 0 ? var.firewall_egress_primary_subnet : var.firewall_egress_ha_subnet
  key_name               = aws_key_pair.key_pair.key_name
  iam_role               = aws_iam_role.aviatrix_s3_bootstrap_role.id
  bootstrap_bucket_name  = local.s3_bucket_name
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