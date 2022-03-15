# Create Resource Group Query
resource "aws_resourcegroups_group" "aviatrix_resource_group" {
  name = "aviatrix"

  resource_query {
    query = <<JSON
{
  "ResourceTypeFilters": [ "AWS::AllSupported" ],
  "TagFilters": [
    {
      "Key": "ownedBy",
      "Values": ["${var.tags.ownedBy}"]
    }
  ]
}
JSON
  }
  tags = { "Name" = "${var.tag_prefix}-resource-group" }
}

resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_address_space
  tags       = { "Name" = var.vpc_name }
}

resource "aws_default_security_group" "default_security_group" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_subnet" "aviatrix_controller_subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.aviatrix_controller_subnet.cidr_block
  availability_zone = var.aviatrix_controller_subnet.availability_zone
  tags              = { "Name" = "${var.tag_prefix}-${var.aviatrix_controller_subnet.name}" }
}

resource "aws_subnet" "aviatrix_copilot_subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.aviatrix_copilot_subnet.cidr_block
  availability_zone = var.aviatrix_copilot_subnet.availability_zone
  tags              = { "Name" = "${var.tag_prefix}-${var.aviatrix_copilot_subnet.name}" }
}

resource "aws_subnet" "additional_subnets" {
  for_each          = var.additional_subnets
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone
  tags              = { "Name" = each.key }
}

resource "aws_internet_gateway" "vpc_internet_gateway" {
  vpc_id = aws_vpc.vpc.id
  tags   = { "Name" = "${var.tag_prefix}-internet-gateway" }
}

resource "aws_route_table" "vpc_route_table" {
  vpc_id = aws_vpc.vpc.id
  tags   = { "Name" = "${var.tag_prefix}-route-table" }
}

resource "aws_route" "internet_route" {
  route_table_id         = aws_route_table.vpc_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.vpc_internet_gateway.id
}

resource "aws_route_table_association" "aviatrix_controller_route_table_assoc" {
  subnet_id      = aws_subnet.aviatrix_controller_subnet.id
  route_table_id = aws_route_table.vpc_route_table.id
}

resource "aws_route_table_association" "aviatrix_copilot_route_table_assoc" {
  subnet_id      = aws_subnet.aviatrix_copilot_subnet.id
  route_table_id = aws_route_table.vpc_route_table.id
}

resource "aws_key_pair" "key_pair" {
  key_name   = var.aws_key_pair_name
  public_key = var.aws_key_pair_public_key
  tags       = { "Name" = "${var.tag_prefix}-key-pair" }
}

# Generates random password Aviatrix Controller admin credentials
resource "random_password" "aviatrix_controller_password" {
  length           = 24
  special          = true
  min_lower        = 2
  min_numeric      = 2
  min_special      = 2
  min_upper        = 2
  override_special = "_@$*()!"
}

# Stores the generated credential as an AWS Systems Management (SSM) Secret Parameter
resource "aws_ssm_parameter" "aviatrix_controller_secret_parameter" {
  name        = "/aviatrix/controller/password"
  description = "The local password for Aviatrix Controller."
  type        = "SecureString"
  value       = random_password.aviatrix_controller_password.result
  tags        = { "Name" = "${var.tag_prefix}-controller-password" }
}

# Creates Aviatrix Controller Security Group
resource "aws_security_group" "aviatrix_controller_security_group" {
  name        = var.aviatrix_controller_security_group_name
  description = "Aviatrix - Controller Security Group"
  vpc_id      = aws_vpc.vpc.id
  tags        = { "Name" = var.aviatrix_controller_security_group_name }
}

# Creates Ingress Rule to allow user public IP addresses for the Aviatrix Controller
resource "aws_security_group_rule" "aviatrix_controller_security_group_ingress_rule" {
  description       = "Allow User Assigned IP addresses inbound to Aviatrix Controller."
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = var.allowed_ips
  security_group_id = aws_security_group.aviatrix_controller_security_group.id
}

# Creates Egress Rule to allow internet traffic for the Aviatrix Controller
resource "aws_security_group_rule" "aviatrix_controller_security_group_egress_rule" {
  description       = "Allow default route outbound to internet."
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.aviatrix_controller_security_group.id
}

# Creates Ingress Rule to allow CoPilot access to the Aviatrix Controller
resource "aws_security_group_rule" "aviatrix_controller_security_group_ingress_allow_copilot" {
  description       = "Allow CoPilot inbound to Aviatrix Controller."
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["${local.copilot_private_ip}/32"]
  security_group_id = aws_security_group.aviatrix_controller_security_group.id
}

# Creates Public IP Address for Aviatrix Controller
resource "aws_eip" "aviatrix_controller_eip" {
  vpc  = true
  tags = { "Name" = "${var.tag_prefix}-controller-eip" }
}

# Creates Network Interface for Aviatrix Controller
resource "aws_network_interface" "aviatrix_controller_network_interface" {
  subnet_id       = aws_subnet.aviatrix_controller_subnet.id
  security_groups = [aws_security_group.aviatrix_controller_security_group.id]
  private_ips     = [local.controller_private_ip]
  tags            = { "Name" = "${var.tag_prefix}-controller-eni" }

  lifecycle {
    ignore_changes = [tags, security_groups, subnet_id]
  }
}

# Creates Aviatrix Controller Instance
resource "aws_instance" "aviatrix_controller_instance" {
  ami                     = local.controller_ami_id
  instance_type           = var.aviatrix_controller_instance_size
  key_name                = aws_key_pair.key_pair.key_name
  iam_instance_profile    = aws_iam_instance_profile.aviatrix_role_ec2_profile.name
  disable_api_termination = false
  monitoring              = true
  ebs_optimized           = true
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  network_interface {
    network_interface_id = aws_network_interface.aviatrix_controller_network_interface.id
    device_index         = 0
  }

  root_block_device {
    encrypted   = true
    volume_size = var.aviatrix_controller_root_volume_size
    volume_type = var.aviatrix_controller_root_volume_type
  }

  tags = { "Name" = var.aviatrix_controller_name }

  lifecycle {
    ignore_changes = [
      ami, key_name, user_data, network_interface
    ]
  }
}

# Associates Public IP Address to Aviatrix Controller Instance.
resource "aws_eip_association" "aviatrix_controller_eip_assoc" {
  instance_id   = aws_instance.aviatrix_controller_instance.id
  allocation_id = aws_eip.aviatrix_controller_eip.id
}

# Python Script to Bootstrap the Aviatrix Controller by adding Admin Email, License, Reset Password, Upgrade Controller.
module "aviatrix_controller_initialize" {
  depends_on = [
    aws_instance.aviatrix_controller_instance
  ]
  source                              = "git::https://github.com/t-dever/public-reusable-aviatrix-terraform-modules//modules/aviatrix/controller_initialize?ref=improveAwsController"
  aviatrix_controller_public_ip       = aws_eip.aviatrix_controller_eip.public_ip
  aviatrix_controller_private_ip      = local.controller_private_ip
  aviatrix_controller_password        = random_password.aviatrix_controller_password.result
  aviatrix_controller_admin_email     = var.aviatrix_controller_admin_email
  aviatrix_controller_version         = var.aviatrix_controller_version
  aviatrix_controller_customer_id     = var.aviatrix_controller_customer_id
  aviatrix_aws_primary_account_name   = var.aviatrix_aws_primary_account_name
  aviatrix_aws_primary_account_number = data.aws_caller_identity.current.account_id
  aviatrix_aws_role_app_arn           = aws_iam_role.aviatrix_role_app.arn
  aviatrix_aws_role_ec2_arn           = aws_iam_role.aviatrix_role_ec2.arn
  enable_security_group_management    = false
  aws_gov                             = local.is_aws_gov
}

# Creates CoPilot Public IP Address
resource "aws_eip" "aviatrix_copilot_eip" {
  vpc  = true
  tags = { "Name" = "${var.tag_prefix}-copilot-eip" }
}

data "external" "get_aviatrix_gateway_cidrs" {
  depends_on = [
    module.aviatrix_controller_initialize
  ]
  program = ["python3", "${path.module}/get_security_group_rules.py"]
  query = {
    region = "${var.region}"
  }
}

# Creates Aviatrix Copilot Security Group
resource "aws_security_group" "aviatrix_copilot_security_group" {
  name        = var.aviatrix_copilot_security_group_name
  description = "Aviatrix - CoPilot Security Group"
  vpc_id      = aws_vpc.vpc.id
  tags        = { "Name" = var.aviatrix_copilot_security_group_name }
}

# Creates Egress Rule to allow internet traffic for the Aviatrix CoPilot
resource "aws_security_group_rule" "aviatrix_copilot_security_group_egress_rule" {
  description       = "Allow default route outbound to internet."
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.aviatrix_copilot_security_group.id
}

# Creates Ingress Rule to allow user public IP addresses for the Aviatrix CoPilot
resource "aws_security_group_rule" "aviatrix_copilot_security_group_ingress_rule" {
  description       = "Allow User Assigned IP addresses inbound to Aviatrix CoPilot."
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = var.allowed_ips
  security_group_id = aws_security_group.aviatrix_copilot_security_group.id
}

# Creates Ingress Rule to allow Aviatrix Gateways Syslog Access to CoPilot
resource "aws_security_group_rule" "aviatrix_copilot_security_group_ingress_gateways_syslog_rule" {
  count             = var.enable_auto_aviatrix_copilot_security_group ? 1 : 0
  description       = "Allow Gateways access to send Rsyslog to Aviatrix CoPilot."
  type              = "ingress"
  from_port         = 0
  to_port           = 5000
  protocol          = "udp"
  cidr_blocks       = length(jsondecode(data.external.get_aviatrix_gateway_cidrs.result.gateway_cidrs)) == 0 ? [] : jsondecode(data.external.get_aviatrix_gateway_cidrs.result.gateway_cidrs)
  security_group_id = aws_security_group.aviatrix_copilot_security_group.id
}

# Creates Ingress Rule to allow Aviatrix Gateways Flow Logs Access to CoPilot
resource "aws_security_group_rule" "aviatrix_copilot_security_group_ingress_gateways_flow_logs_rule" {
  count             = var.enable_auto_aviatrix_copilot_security_group ? 1 : 0
  description       = "Allow Gateways access to send Flow Logs to Aviatrix CoPilot."
  type              = "ingress"
  from_port         = 0
  to_port           = 31283
  protocol          = "udp"
  cidr_blocks       = length(jsondecode(data.external.get_aviatrix_gateway_cidrs.result.gateway_cidrs)) == 0 ? [] : jsondecode(data.external.get_aviatrix_gateway_cidrs.result.gateway_cidrs)
  security_group_id = aws_security_group.aviatrix_copilot_security_group.id
}

# Creates CoPilot Network Interface
resource "aws_network_interface" "aviatrix_copilot_network_interface" {
  subnet_id       = aws_subnet.aviatrix_copilot_subnet.id
  security_groups = [aws_security_group.aviatrix_copilot_security_group.id]
  private_ips     = [local.copilot_private_ip]
  tags            = { "Name" = "${var.tag_prefix}-copilot-eni" }
  lifecycle {
    ignore_changes = [tags, security_groups, subnet_id]
  }
}

# Creates CoPilot Instance
resource "aws_instance" "aviatrix_copilot_instance" {
  ami           = local.copilot_ami_id
  instance_type = var.aviatrix_copilot_instance_size
  key_name      = aws_key_pair.key_pair.key_name
  monitoring    = true
  ebs_optimized = true

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  network_interface {
    network_interface_id = aws_network_interface.aviatrix_copilot_network_interface.id
    device_index         = 0
  }

  root_block_device {
    encrypted   = true
    volume_size = var.aviatrix_copilot_root_volume_size
    volume_type = var.aviatrix_copilot_root_volume_type
  }

  tags = { "Name" = var.aviatrix_copilot_name }
}

# Associates Public IP Address to Aviatrix CoPilot Instance.
resource "aws_eip_association" "aviatrix_copilot_eip_assoc" {
  instance_id   = aws_instance.aviatrix_copilot_instance.id
  allocation_id = aws_eip.aviatrix_copilot_eip.id
}

# Attaches extra volumes to CoPilot Instance
resource "aws_volume_attachment" "aviatrix_copilot_ebs_attach" {
  for_each    = var.aviatrix_copilot_additional_volumes
  device_name = each.value.device_name
  volume_id   = each.value.volume_id
  instance_id = aws_instance.aviatrix_copilot_instance.id
}

