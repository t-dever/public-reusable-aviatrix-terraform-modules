# Create Virtual Private Connection (Virtual Network)
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_address_space
  tags       = { "Name" = var.vpc_name }
}

# Create Default Security Group for VPC
resource "aws_default_security_group" "default_security_group" {
  vpc_id = aws_vpc.vpc.id
}

# Create Transit Gateway Primary Subnet
resource "aws_subnet" "aviatrix_transit_primary_subnet" {
  count             = var.insane_mode ? 0 : 1
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = local.transit_gateway_subnet
  availability_zone = length(var.aviatrix_transit_availability_zone_1) > 0 ? var.aviatrix_transit_availability_zone_1 : "${var.region}a"
  tags              = { "Name" = "${var.aviatrix_transit_primary_subnet_name}" }
}

# Create Transit Gateway HA Subnet
resource "aws_subnet" "aviatrix_transit_ha_subnet" {
  count             = var.insane_mode ? 0 : var.enable_aviatrix_transit_gateway_ha ? 1 : 0
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = local.transit_gateway_ha_subnet
  availability_zone = length(var.aviatrix_transit_availability_zone_2) > 0 ? var.aviatrix_transit_availability_zone_2 : "${var.region}b"
  tags              = { "Name" = "${var.aviatrix_transit_ha_subnet_name}" }
}

# Create Firewall Management Primary Subnet
resource "aws_subnet" "aviatrix_firewall_mgmt_primary_subnet" {
  count             = var.enable_aviatrix_transit_firenet ? 1 : 0
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = local.firewall_mgmt_primary_subnet
  availability_zone = length(var.aviatrix_transit_availability_zone_1) > 0 ? var.aviatrix_transit_availability_zone_1 : "${var.region}a"
  tags              = { "Name" = "${var.aviatrix_firewall_mgmt_primary_subnet_name}" }
}

# Create Firewall Management HA Subnet
resource "aws_subnet" "aviatrix_firewall_mgmt_ha_subnet" {
  count             = var.enable_aviatrix_transit_firenet ? 1 : 0
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = local.firewall_mgmt_ha_subnet
  availability_zone = length(var.aviatrix_transit_availability_zone_2) > 0 ? var.aviatrix_transit_availability_zone_2 : "${var.region}b"
  tags              = { "Name" = "${var.aviatrix_firewall_mgmt_ha_subnet_name}" }
}

# Create Firewall Egress Primary Subnet
resource "aws_subnet" "aviatrix_firewall_egress_primary_subnet" {
  count             = var.enable_aviatrix_transit_firenet ? 1 : 0
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = local.firewall_egress_primary_subnet
  availability_zone = length(var.aviatrix_transit_availability_zone_1) > 0 ? var.aviatrix_transit_availability_zone_1 : "${var.region}a"
  tags              = { "Name" = "${var.aviatrix_firewall_egress_primary_subnet_name}" }
}

# Create Firewall Egress HA Subnet
resource "aws_subnet" "aviatrix_firewall_egress_ha_subnet" {
  count             = var.enable_aviatrix_transit_firenet ? 1 : 0
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = local.firewall_egress_ha_subnet
  availability_zone = length(var.aviatrix_transit_availability_zone_2) > 0 ? var.aviatrix_transit_availability_zone_2 : "${var.region}b"
  tags              = { "Name" = "${var.aviatrix_firewall_egress_ha_subnet_name}" }
}

# Creates Internet Gateway for VPC
resource "aws_internet_gateway" "vpc_internet_gateway" {
  depends_on = [
    aws_vpc.vpc
  ]
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
  count          = var.insane_mode ? 0 : 1
  subnet_id      = aws_subnet.aviatrix_transit_primary_subnet[0].id
  route_table_id = aws_route_table.vpc_route_table.id
}

# Associate Route Table to Aviatrix Transit HA Subnet
resource "aws_route_table_association" "aviatrix_transit_ha_route_table_assoc" {
  count          = var.insane_mode ? 0 : var.enable_aviatrix_transit_gateway_ha ? 1 : 0
  subnet_id      = aws_subnet.aviatrix_transit_ha_subnet[0].id
  route_table_id = aws_route_table.vpc_route_table.id
}

# Associate Route Table to Firewall Mgmt Primary Subnet
resource "aws_route_table_association" "aviatrix_firewall_mgmt_primary_route_table_assoc" {
  count          = var.enable_aviatrix_transit_firenet ? 1 : 0
  subnet_id      = aws_subnet.aviatrix_firewall_mgmt_primary_subnet[0].id
  route_table_id = aws_route_table.vpc_route_table.id
}

# Associate Route Table to Firewall Mgmt HA Subnet
resource "aws_route_table_association" "aviatrix_firewall_mgmt_ha_route_table_assoc" {
  count          = var.enable_aviatrix_transit_firenet ? 1 : 0
  subnet_id      = aws_subnet.aviatrix_firewall_mgmt_ha_subnet[0].id
  route_table_id = aws_route_table.vpc_route_table.id
}

# Associate Route Table to Firewall Ingress/Egress Primary Subnet
resource "aws_route_table_association" "aviatrix_firewall_egress_primary_route_table_assoc" {
  count          = var.enable_aviatrix_transit_firenet ? 1 : 0
  subnet_id      = aws_subnet.aviatrix_firewall_egress_primary_subnet[0].id
  route_table_id = aws_route_table.vpc_route_table.id
}

# Associate Route Table to Firewall Ingress/Egress HA Subnet
resource "aws_route_table_association" "aviatrix_firewall_egress_ha_route_table_assoc" {
  count          = var.enable_aviatrix_transit_firenet ? 1 : 0
  subnet_id      = aws_subnet.aviatrix_firewall_egress_ha_subnet[0].id
  route_table_id = aws_route_table.vpc_route_table.id
}

# Deploy Aviatrix Transit Gateways
resource "aviatrix_transit_gateway" "aviatrix_transit_gateway" {
  depends_on = [
    aws_subnet.aviatrix_transit_primary_subnet,
    aws_subnet.aviatrix_transit_ha_subnet,
    aws_subnet.aviatrix_firewall_mgmt_primary_subnet,
    aws_subnet.aviatrix_firewall_mgmt_ha_subnet,
    aws_subnet.aviatrix_firewall_egress_primary_subnet,
    aws_subnet.aviatrix_firewall_egress_ha_subnet,
    aws_internet_gateway.vpc_internet_gateway
  ]
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
  enable_encrypt_volume         = true
  insane_mode                   = var.insane_mode ? true : false
  insane_mode_az                = var.insane_mode ? length(var.aviatrix_transit_availability_zone_1) > 0 ? var.aviatrix_transit_availability_zone_1 : "${var.region}a" : null
  ha_insane_mode_az             = var.enable_aviatrix_transit_gateway_ha && var.insane_mode ? length(var.aviatrix_transit_availability_zone_2) > 0 ? var.aviatrix_transit_availability_zone_2 : "${var.region}b" : null
  tags                          = var.tags
}

# Create Aviatrix Firenet
resource "aviatrix_firenet" "firenet" {
  depends_on = [
    aviatrix_transit_gateway.aviatrix_transit_gateway
  ]
  count                                = var.enable_aviatrix_transit_firenet ? 1 : 0
  vpc_id                               = aws_vpc.vpc.id
  inspection_enabled                   = true
  egress_enabled                       = var.enable_firenet_egress
  keep_alive_via_lan_interface_enabled = false
  manage_firewall_instance_association = false
  east_west_inspection_excluded_cidrs  = []
  egress_static_cidrs                  = []
}

# Creates Firewall Management Security Group
resource "aws_security_group" "aviatrix_firewall_mgmt_security_group" {
  #checkov:skip=CKV2_AWS_5: "Ensure that Security Groups are attached to another resource" REASON: This Security Group is attached to firewall management network interface. Using 'aws_network_interface_sg_attachment'
  count       = var.enable_aviatrix_transit_firenet ? 1 : 0
  name        = var.firewall_mgmt_security_group_name
  description = "Aviatrix - Firewall Management Security Group"
  vpc_id      = aws_vpc.vpc.id
  tags        = { "Name" = var.firewall_mgmt_security_group_name }
}

# Creates Ingress Rule to allow user public IP addresses to Firewall Management
resource "aws_security_group_rule" "aviatrix_firewall_mgmt_ingress_https_user_public_ips" {
  count             = var.enable_aviatrix_transit_firenet ? 1 : 0
  description       = "Allow User Assigned IP addresses inbound to Firewall Management Subnets."
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = var.firewall_allowed_ips
  security_group_id = aws_security_group.aviatrix_firewall_mgmt_security_group[0].id
}

# Creates S3 Bucket, IAM, bucket objects required for bootstrapping
module "palo_alto_bootstrap" {
  count                                 = var.deploy_palo_alto_firewalls != null ? 1 : 0
  source                                = "./firewalls/palo_alto"
  s3_bucket_name                        = var.deploy_palo_alto_firewalls.s3_bucket_name
  s3_iam_role_name                      = var.deploy_palo_alto_firewalls.s3_iam_role_name
  aws_key_pair_public_key               = var.deploy_palo_alto_firewalls.aws_key_pair_public_key
  aws_firewall_key_pair_name            = var.deploy_palo_alto_firewalls.aws_firewall_key_pair_name
  firewall_private_key_location         = var.deploy_palo_alto_firewalls.firewall_private_key_location
  firewall_password                     = var.deploy_palo_alto_firewalls.firewall_password
  store_firewall_password_in_ssm        = var.deploy_palo_alto_firewalls.store_firewall_password_in_ssm
  aws_vpc_id                            = aws_vpc.vpc.id
  aviatrix_transit_primary_gateway_name = aviatrix_transit_gateway.aviatrix_transit_gateway.gw_name
  aviatrix_transit_ha_gateway_name      = aviatrix_transit_gateway.aviatrix_transit_gateway.ha_gw_name
  firewall_mgmt_primary_subnet          = aws_subnet.aviatrix_firewall_mgmt_primary_subnet[0].cidr_block
  firewall_mgmt_ha_subnet               = aws_subnet.aviatrix_firewall_mgmt_ha_subnet[0].cidr_block
  firewall_egress_primary_subnet        = aws_subnet.aviatrix_firewall_egress_primary_subnet[0].cidr_block
  firewall_egress_ha_subnet             = aws_subnet.aviatrix_firewall_egress_ha_subnet[0].cidr_block
  firewalls                             = var.deploy_palo_alto_firewalls.firewalls
  firewall_image                        = var.deploy_palo_alto_firewalls.firewall_image
  firewall_image_version                = var.deploy_palo_alto_firewalls.firewall_image_version
  firewall_size                         = var.deploy_palo_alto_firewalls.firewall_size
}

# Attach Security Group to Firewall Mgmt Interface
resource "aws_network_interface_sg_attachment" "palo_attach_firewall_mgmt_security_group" {
  count                = var.deploy_palo_alto_firewalls != null ? module.palo_alto_bootstrap[0].firewall_management_interface_ids : 0
  security_group_id    = aws_security_group.aviatrix_firewall_mgmt_security_group[0].id
  network_interface_id = module.palo_alto_bootstrap[0].firewall_management_interface_ids[count.index]
}
