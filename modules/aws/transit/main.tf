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

# Creates AWS Key Pair based on SSH Public Key Provided
resource "aws_key_pair" "key_pair" {
  key_name   = var.firewall_aws_key_pair_name
  public_key = var.firewall_public_key
  tags       = { "Name" = var.firewall_aws_key_pair_name }
}

module "palo_alto_bootstrap" {
  count                   = local.is_palo && length(var.firewalls) > 0 ? 1 : 0
  source                  = "./firewalls/palo_alto"
  s3_bucket_name          = var.s3_bucket_name
  s3_iam_role_name        = var.s3_iam_role_name
  aws_key_pair_public_key = var.firewall_public_key
  firewall_admin_username = var.firewall_admin_username
}

resource "aviatrix_firewall_instance" "firewall_instance" {
  count                  = var.enable_aviatrix_transit_firenet && length(var.firewalls) > 0 ? length(var.firewalls) : 0
  vpc_id                 = aws_vpc.vpc.id
  firenet_gw_name        = count.index % 2 == 0 ? aviatrix_transit_gateway.aviatrix_transit_gateway.gw_name : aviatrix_transit_gateway.aviatrix_transit_gateway.ha_gw_name
  firewall_name          = var.firewalls[count.index].name
  firewall_image         = var.firewall_image
  firewall_image_version = var.firewall_image_version
  firewall_size          = var.firewalls[count.index].size
  management_subnet      = local.is_palo ? count.index % 2 == 0 ? local.firewall_mgmt_primary_subnet : local.firewall_mgmt_ha_subnet : null
  egress_subnet          = count.index % 2 == 0 ? local.firewall_egress_primary_subnet : local.firewall_egress_ha_subnet
  key_name               = aws_key_pair.key_pair.key_name
  iam_role               = module.palo_alto_bootstrap[0].palo_alto_iam_id
  bootstrap_bucket_name  = module.palo_alto_bootstrap[0].bootstrap_bucket_name
}

# Associate Firewall to Firenet
resource "aviatrix_firewall_instance_association" "firewall_instance_association" {
  count                = var.enable_aviatrix_transit_firenet && length(var.firewalls) > 0 ? length(var.firewalls) : 0
  vpc_id               = aws_vpc.vpc.id
  firenet_gw_name      = count.index % 2 == 0 ? aviatrix_transit_gateway.aviatrix_transit_gateway.gw_name : aviatrix_transit_gateway.aviatrix_transit_gateway.ha_gw_name
  instance_id          = aviatrix_firewall_instance.firewall_instance[count.index].instance_id
  firewall_name        = aviatrix_firewall_instance.firewall_instance[count.index].firewall_name
  lan_interface        = aviatrix_firewall_instance.firewall_instance[count.index].lan_interface
  management_interface = aviatrix_firewall_instance.firewall_instance[count.index].management_interface
  egress_interface     = aviatrix_firewall_instance.firewall_instance[count.index].egress_interface
  attached             = true
}

# Creates Firewall Management Security Group
resource "aws_security_group" "aviatrix_firewall_mgmt_security_group" {
  count       = var.enable_aviatrix_transit_firenet && length(var.firewalls) > 0 ? 1 : 0
  name        = var.firewall_mgmt_security_group_name
  description = "Aviatrix - Firewall Management Security Group"
  vpc_id      = aws_vpc.vpc.id
  tags        = { "Name" = var.firewall_mgmt_security_group_name }
}

# Creates Ingress Rule to allow user public IP addresses to Firewall Management
resource "aws_security_group_rule" "aviatrix_firewall_mgmt_ingress_https_user_public_ips" {
  count             = var.enable_aviatrix_transit_firenet && length(var.firewalls) > 0 ? 1 : 0
  description       = "Allow User Assigned IP addresses inbound to Firewall Management Subnets."
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = var.firewall_allowed_ips
  security_group_id = aws_security_group.aviatrix_firewall_mgmt_security_group[0].id
}

# Attach Security Group to Firewall Mgmt Interface
resource "aws_network_interface_sg_attachment" "attach_firewall_mgmt_security_group" {
  count                = var.enable_aviatrix_transit_firenet && length(var.firewalls) > 0 ? length(var.firewalls) : 0
  security_group_id    = aws_security_group.aviatrix_firewall_mgmt_security_group[0].id
  network_interface_id = aviatrix_firewall_instance.firewall_instance[count.index].management_interface
}

# SSH into Firewalls and change Admin Password
resource "null_resource" "initial_config" {
  depends_on = [
    module.palo_alto_bootstrap,
    aviatrix_firewall_instance.firewall_instance
  ]
  count = var.enable_aviatrix_transit_firenet && length(var.firewalls) > 0 && local.is_palo ? length(var.firewalls) : 0
  provisioner "local-exec" {
    command = "python3 ${path.module}/firewalls/palo_alto/palo_bootstrap.py"
    environment = {
      PALO_IP_ADDRESS           = aviatrix_firewall_instance.firewall_instance[count.index].public_ip
      PALO_USERNAME             = var.firewall_admin_username
      PALO_NEW_PASSWORD         = module.palo_alto_bootstrap[0].firewall_password
      PALO_PRIVATE_KEY_LOCATION = var.firewall_private_key_location
    }
  }
}

# Performs vendor integration to automatically add routes
# tflint-ignore: terraform_unused_declarations
data "aviatrix_firenet_vendor_integration" "vendor_integration" {
  depends_on = [
    null_resource.initial_config
  ]
  count         = var.enable_aviatrix_transit_firenet && length(var.firewalls) > 0 ? length(var.firewalls) : 0
  vpc_id        = aviatrix_firewall_instance.firewall_instance[count.index].vpc_id
  instance_id   = aviatrix_firewall_instance.firewall_instance[count.index].instance_id
  vendor_type   = local.is_palo ? "Palo Alto Networks VM-Series" : "Generic"
  public_ip     = aviatrix_firewall_instance.firewall_instance[count.index].public_ip
  firewall_name = aviatrix_firewall_instance.firewall_instance[count.index].firewall_name
  username      = var.firewall_admin_username
  password      = local.is_palo ? module.palo_alto_bootstrap[0].firewall_password : null
  save          = true
}
