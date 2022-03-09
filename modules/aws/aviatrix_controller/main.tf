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

# Aviatrix Controller Deployment
resource "random_password" "aviatrix_controller_password" {
  length           = 24
  special          = true
  min_lower        = 2
  min_numeric      = 2
  min_special      = 2
  min_upper        = 2
  override_special = "_@$*()!"
}

resource "aws_ssm_parameter" "aviatrix_controller_secret_parameter" {
  name        = "/aviatrix/controller/password"
  description = "The local password for Aviatrix Controller."
  type        = "SecureString"
  value       = random_password.aviatrix_controller_password.result
  tags        = { "Name" = "${var.tag_prefix}-controller-password" }
}

resource "aws_security_group" "aviatrix_controller_security_group" {
  name        = var.aviatrix_controller_security_group_name
  description = "Aviatrix - Controller Security Group"
  vpc_id      = aws_vpc.vpc.id
  tags        = { "Name" = "${var.tag_prefix}-controller-security-group" }
}

resource "aws_security_group_rule" "aviatrix_controller_security_group_ingress_rule" {
  description       = "Allow User Assigned IP addresses inbound to Aviatrix Controller."
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = var.allowed_ips
  security_group_id = aws_security_group.aviatrix_controller_security_group.id
}

resource "aws_security_group_rule" "aviatrix_controller_security_group_egress_rule" {
  description       = "Allow default route outbound to internet."
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.aviatrix_controller_security_group.id
}

resource "aws_eip" "aviatrix_controller_eip" {
  vpc  = true
  tags = { "Name" = "${var.tag_prefix}-controller-eip" }
}

resource "aws_network_interface" "aviatrix_controller_network_interface" {
  subnet_id       = aws_subnet.aviatrix_controller_subnet.id
  security_groups = [aws_security_group.aviatrix_controller_security_group.id]

  tags = { "Name" = "${var.tag_prefix}-controller-eni" }

  lifecycle {
    ignore_changes = [tags, security_groups, subnet_id]
  }
}

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

  tags = { "Name" = "${var.tag_prefix}-${var.aviatrix_controller_name}" }

  lifecycle {
    ignore_changes = [
      ami, key_name, user_data, network_interface
    ]
  }
}

resource "aws_eip_association" "aviatrix_controller_eip_assoc" {
  instance_id   = aws_instance.aviatrix_controller_instance.id
  allocation_id = aws_eip.aviatrix_controller_eip.id
}

data "aws_network_interface" "aviatrix_controller_network_interface" {
  id = aws_network_interface.aviatrix_controller_network_interface.id
}

resource "null_resource" "initial_config" {
  depends_on = [
    aws_instance.aviatrix_controller_instance
  ]
  triggers = {
    "id" = aws_instance.aviatrix_controller_instance.id
  }
  provisioner "local-exec" {
    command = "python3 ${path.module}/initial_controller_setup.py"
    environment = {
      AVIATRIX_CONTROLLER_PUBLIC_IP  = aws_eip.aviatrix_controller_eip.public_ip
      AVIATRIX_CONTROLLER_PRIVATE_IP = data.aws_network_interface.aviatrix_controller_network_interface.private_ip
      AVIATRIX_CONTROLLER_PASSWORD   = random_password.aviatrix_controller_password.result
      ADMIN_EMAIL                    = var.aviatrix_controller_admin_email
      CONTROLLER_VERSION             = var.aviatrix_controller_version
      CUSTOMER_ID                    = var.aviatrix_controller_customer_id
      AWS_PRIMARY_ACCOUNT_NAME       = var.aviatrix_aws_primary_account_name
      AWS_PRIMARY_ACCOUNT_NUMBER     = data.aws_caller_identity.current.account_id
    }
  }
}

# Aviatrix Co-Pilot Deployment
resource "aws_eip" "aviatrix_copilot_eip" {
  vpc  = true
  tags = { "Name" = "${var.tag_prefix}-copilot-eip" }
}

resource "aws_network_interface" "aviatrix_copilot_network_interface" {
  subnet_id       = aws_subnet.aviatrix_copilot_subnet.id
  security_groups = [aws_security_group.aviatrix_controller_security_group.id]
  tags            = { "Name" = "${var.tag_prefix}-copilot-eni" }
  lifecycle {
    ignore_changes = [tags, security_groups, subnet_id]
  }
}

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

  tags = { "Name" = "${var.tag_prefix}-${var.aviatrix_copilot_name}" }
}

resource "aws_eip_association" "aviatrix_copilot_eip_assoc" {
  instance_id   = aws_instance.aviatrix_copilot_instance.id
  allocation_id = aws_eip.aviatrix_copilot_eip.id
}

resource "aws_volume_attachment" "ebs_att" {
  for_each    = var.aviatrix_copilot_additional_volumes
  device_name = each.value.device_name
  volume_id   = each.value.volume_id
  instance_id = aws_instance.aviatrix_copilot_instance.id
}
