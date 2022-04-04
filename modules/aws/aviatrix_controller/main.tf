# Create Resource Group Query
resource "aws_resourcegroups_group" "resource_group" {
  name = "aviatrix"

  resource_query {
    query = <<JSON
{
  "ResourceTypeFilters": [ "AWS::AllSupported" ],
  "TagFilters": [
    {
      "Key": "ownedBy",
      "Values": ["${var.aws_tags.ownedBy}"]
    }
  ]
}
JSON
  }
  tags = { "Name" = length(var.tag_prefix) > 0 ? "${var.tag_prefix}-rg" : var.aws_resource_group_name }
}

# Generates random password Aviatrix Controller admin credentials
resource "random_password" "aviatrix_controller_password" {
  count            = length(var.aviatrix_controller_admin_password) == 0 ? 1 : 0
  length           = 24
  special          = true
  min_lower        = 2
  min_numeric      = 2
  min_special      = 2
  min_upper        = 2
  override_special = "_@$*()!"
}

# Generates random password Aviatrix Copilot credentials
resource "random_password" "aviatrix_copilot_password" {
  count            = var.aws_copilot_deploy ? 1 : 0
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
  count       = var.store_credentials_in_ssm ? 1 : 0
  name        = "/aviatrix/controller/password"
  description = "The local password for Aviatrix Controller."
  type        = "SecureString"
  value       = random_password.aviatrix_controller_password[0].result
  tags        = { "Name" = "${var.tag_prefix}-controller-password" }
}

# Stores the generated credential as an AWS Systems Management (SSM) Secret Parameter
resource "aws_ssm_parameter" "aviatrix_copilot_secret_parameter" {
  count       = var.aws_copilot_deploy && var.store_credentials_in_ssm ? 1 : 0
  name        = "/aviatrix/copilot/password"
  description = "The copilot password used to authenticate with the controller using read-only."
  type        = "SecureString"
  value       = random_password.aviatrix_copilot_password[0].result
  tags        = { "Name" = "${var.tag_prefix}-copilot-password" }
}

# Creates AWS Key Pair based on SSH Public Key Provided
resource "aws_key_pair" "key_pair" {
  count      = length(var.aws_key_pair_public_key) > 0 ? 1 : 0
  key_name   = var.aws_key_pair_name != "aviatrix-controller-key" ? var.aws_key_pair_name : length(var.tag_prefix) > 0 ? "${var.tag_prefix}-controller-key" : var.aws_key_pair_name
  public_key = var.aws_key_pair_public_key
  tags       = { "Name" = var.aws_key_pair_name != "aviatrix-controller-key" ? var.aws_key_pair_name : length(var.tag_prefix) > 0 ? "${var.tag_prefix}-controller-key" : var.aws_key_pair_name }
}

# Grabs the attributes for the key pair if ssh public key is not provided
data "aws_key_pair" "key_pair" {
  count    = length(var.aws_key_pair_public_key) > 0 ? 0 : 1
  key_name = var.aws_key_pair_name
}

# Creates AWS VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.aws_vpc_address_space
  tags       = { "Name" = var.aws_vpc_name != "aviatrix-controller-vpc" ? var.aws_vpc_name : length(var.tag_prefix) > 0 ? "${var.tag_prefix}-controller-vpc" : var.aws_vpc_name }
}

# Creates AWS VPC Default Security Group
resource "aws_default_security_group" "default_security_group" {
  vpc_id = aws_vpc.vpc.id
}

# Create Aviatrix Controller Subnet
resource "aws_subnet" "controller_subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.aws_controller_subnet.cidr_block
  availability_zone = var.aws_controller_subnet.availability_zone
  tags              = { "Name" = var.aws_controller_subnet.name != "aviatrix-controller" ? var.aws_controller_subnet.name : length(var.tag_prefix) > 0 ? "${var.tag_prefix}-controller-subnet" : var.aws_controller_subnet.name }
}

# Create Aviatrix CoPilot Subnet
resource "aws_subnet" "copilot_subnet" {
  count             = var.aws_copilot_deploy ? 1 : 0
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.aws_copilot_subnet.cidr_block
  availability_zone = var.aws_copilot_subnet.availability_zone
  tags              = { "Name" = var.aws_copilot_subnet.name != "aviatrix-copilot" ? var.aws_copilot_subnet.name : length(var.tag_prefix) > 0 ? "${var.tag_prefix}-copilot-subnet" : var.aws_copilot_subnet.name }
}

# Create Additional Subnets in the VPC
resource "aws_subnet" "additional_subnets" {
  count             = length(var.aws_additional_subnets)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.aws_additional_subnets[count.index].cidr_block
  availability_zone = var.aws_additional_subnets[count.index].availability_zone
  tags              = { "Name" = var.aws_additional_subnets[count.index].name }
}

# Create Internet Gateway (IGW)
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id
  tags   = { "Name" = var.aws_internet_gateway_name != "aviatrix-internet-gateway" ? var.aws_internet_gateway_name : length(var.tag_prefix) > 0 ? "${var.tag_prefix}-internet-gateway" : var.aws_internet_gateway_name }
}

# Create AWS Route Table for VPC
resource "aws_route_table" "vpc_route_table" {
  vpc_id = aws_vpc.vpc.id
  tags   = { "Name" = var.aws_route_table_name != "aviatrix-route-table" ? var.aws_route_table_name : length(var.tag_prefix) > 0 ? "${var.tag_prefix}-route-table" : var.aws_route_table_name }
}

# Creates Default Route to Internet for route table.
resource "aws_route" "internet_route" {
  route_table_id         = aws_route_table.vpc_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet_gateway.id
}

# Associate Route Table to Aviatrix Controller Instance
resource "aws_route_table_association" "controller_subnet_route_table_assoc" {
  subnet_id      = aws_subnet.controller_subnet.id
  route_table_id = aws_route_table.vpc_route_table.id
}

# Associate Route Table to Aviatrix CoPilot Instance
resource "aws_route_table_association" "copilot_subnet_route_table_assoc" {
  count          = var.aws_copilot_deploy ? 1 : 0
  subnet_id      = aws_subnet.copilot_subnet[0].id
  route_table_id = aws_route_table.vpc_route_table.id
}

# Creates Aviatrix Controller Security Group
resource "aws_security_group" "controller_security_group" {
  name        = var.aws_controller_security_group_name != "aviatrix-controller-security-group" ? var.aws_controller_security_group_name : length(var.tag_prefix) > 0 ? "${var.tag_prefix}-controller-security-group" : var.aws_controller_security_group_name
  description = "Aviatrix - Controller Security Group"
  vpc_id      = aws_vpc.vpc.id
  tags        = { "Name" = var.aws_controller_security_group_name != "aviatrix-controller-security-group" ? var.aws_controller_security_group_name : length(var.tag_prefix) > 0 ? "${var.tag_prefix}-controller-security-group" : var.aws_controller_security_group_name }
}

# Creates Ingress Rule to allow user public IP addresses for the Aviatrix Controller
resource "aws_security_group_rule" "controller_security_group_ingress_rule_allow_custom" {
  count             = length(var.aws_controller_security_group_allowed_ips)
  description       = var.aws_controller_security_group_allowed_ips[count.index].description
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = var.aws_controller_security_group_allowed_ips[count.index].cidr_blocks
  security_group_id = aws_security_group.controller_security_group.id
}

# Creates Egress Rule to allow internet traffic for the Aviatrix Controller
resource "aws_security_group_rule" "controller_security_group_egress_rule_allow_internet" {
  description       = "Allow default route outbound to internet."
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.controller_security_group.id
}

# Creates Ingress Rule to allow CoPilot access to the Aviatrix Controller
resource "aws_security_group_rule" "controller_security_group_ingress_rule_allow_copilot" {
  count             = var.aws_copilot_deploy ? 1 : 0
  description       = "Allow CoPilot inbound to Aviatrix Controller."
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["${local.copilot_private_ip}/32"]
  security_group_id = aws_security_group.controller_security_group.id
}

# Creates Public IP Address for Aviatrix Controller
resource "aws_eip" "controller_eip" {
  vpc  = true
  tags        = { "Name" = var.aws_controller_eip_name != "aviatrix-controller-eip" ? var.aws_controller_eip_name : length(var.tag_prefix) > 0 ? "${var.tag_prefix}-controller-eip" : var.aws_controller_eip_name }
}

# # Creates Network Interface for Aviatrix Controller
# resource "aws_network_interface" "controller_network_interface" {
#   subnet_id       = aws_subnet.controller_subnet.id
#   security_groups = [aws_security_group.controller_security_group.id]
#   private_ips     = [local.controller_private_ip]
#   tags            = { "Name" = "${var.aws_controller_eni_name}" }

#   lifecycle {
#     ignore_changes = [tags, security_groups, subnet_id]
#   }
# }



# # Creates Aviatrix Controller Instance
# resource "aws_instance" "controller_instance" {
#   ami                     = local.controller_ami_id
#   instance_type           = var.aws_controller_instance_size
#   key_name                = data.aws_key_pair.key_pair.key_name
#   iam_instance_profile    = aws_iam_instance_profile.iam_role_ec2_profile.name
#   disable_api_termination = false
#   monitoring              = true
#   ebs_optimized           = true
#   metadata_options {
#     http_endpoint = "enabled"
#     http_tokens   = "required"
#   }

#   network_interface {
#     network_interface_id = aws_network_interface.controller_network_interface.id
#     device_index         = 0
#   }

#   root_block_device {
#     encrypted   = true
#     volume_size = var.aws_controller_root_volume_size
#     volume_type = "gp2"
#   }

#   tags = { "Name" = var.aws_controller_name }

#   lifecycle {
#     ignore_changes = [
#       ami, key_name, user_data, network_interface
#     ]
#   }
# }

# # Associates Public IP Address to Aviatrix Controller Instance.
# resource "aws_eip_association" "controller_eip_assoc" {
#   instance_id   = aws_instance.controller_instance.id
#   allocation_id = aws_eip.controller_eip.id
# }






























# # Creates Aviatrix Controller Security Group
# resource "aws_security_group" "aviatrix_controller_security_group" {
#   name        = var.aviatrix_controller_security_group_name
#   description = "Aviatrix - Controller Security Group"
#   vpc_id      = aws_vpc.vpc.id
#   tags        = { "Name" = var.aviatrix_controller_security_group_name }
# }

# # Creates Ingress Rule to allow user public IP addresses for the Aviatrix Controller
# resource "aws_security_group_rule" "aviatrix_controller_security_group_ingress_rule" {
#   description       = "Allow User Assigned IP addresses inbound to Aviatrix Controller."
#   type              = "ingress"
#   from_port         = 443
#   to_port           = 443
#   protocol          = "tcp"
#   cidr_blocks       = var.allowed_ips
#   security_group_id = aws_security_group.aviatrix_controller_security_group.id
# }

# # Creates Egress Rule to allow internet traffic for the Aviatrix Controller
# resource "aws_security_group_rule" "aviatrix_controller_security_group_egress_rule" {
#   description       = "Allow default route outbound to internet."
#   type              = "egress"
#   from_port         = 0
#   to_port           = 0
#   protocol          = "-1"
#   cidr_blocks       = ["0.0.0.0/0"]
#   security_group_id = aws_security_group.aviatrix_controller_security_group.id
# }

# # Creates Ingress Rule to allow CoPilot access to the Aviatrix Controller
# resource "aws_security_group_rule" "aviatrix_controller_security_group_ingress_allow_copilot" {
#   description       = "Allow CoPilot inbound to Aviatrix Controller."
#   type              = "ingress"
#   from_port         = 443
#   to_port           = 443
#   protocol          = "tcp"
#   cidr_blocks       = ["${local.copilot_private_ip}/32"]
#   security_group_id = aws_security_group.aviatrix_controller_security_group.id
# }

# # Creates Public IP Address for Aviatrix Controller
# resource "aws_eip" "aviatrix_controller_eip" {
#   vpc  = true
#   tags = { "Name" = "${var.tag_prefix}-controller-eip" }
# }

# # Creates Network Interface for Aviatrix Controller
# resource "aws_network_interface" "aviatrix_controller_network_interface" {
#   subnet_id       = aws_subnet.aviatrix_controller_subnet.id
#   security_groups = [aws_security_group.aviatrix_controller_security_group.id]
#   private_ips     = [local.controller_private_ip]
#   tags            = { "Name" = "${var.tag_prefix}-controller-eni" }

#   lifecycle {
#     ignore_changes = [tags, security_groups, subnet_id]
#   }
# }

# # Creates Aviatrix Controller Instance
# resource "aws_instance" "aviatrix_controller_instance" {
#   ami                     = local.controller_ami_id
#   instance_type           = var.aviatrix_controller_instance_size
#   key_name                = aws_key_pair.key_pair.key_name
#   iam_instance_profile    = aws_iam_instance_profile.aviatrix_role_ec2_profile.name
#   disable_api_termination = false
#   monitoring              = true
#   ebs_optimized           = true
#   metadata_options {
#     http_endpoint = "enabled"
#     http_tokens   = "required"
#   }

#   network_interface {
#     network_interface_id = aws_network_interface.aviatrix_controller_network_interface.id
#     device_index         = 0
#   }

#   root_block_device {
#     encrypted   = true
#     volume_size = var.aviatrix_controller_root_volume_size
#     volume_type = var.aviatrix_controller_root_volume_type
#   }

#   tags = { "Name" = var.aviatrix_controller_name }

#   lifecycle {
#     ignore_changes = [
#       ami, key_name, user_data, network_interface
#     ]
#   }
# }

# # Associates Public IP Address to Aviatrix Controller Instance.
# resource "aws_eip_association" "aviatrix_controller_eip_assoc" {
#   instance_id   = aws_instance.aviatrix_controller_instance.id
#   allocation_id = aws_eip.aviatrix_controller_eip.id
# }

# # Python Script to Bootstrap the Aviatrix Controller by adding Admin Email, License, Reset Password, Upgrade Controller.
# module "aviatrix_controller_initialize" {
#   depends_on = [
#     aws_instance.aviatrix_controller_instance
#   ]
#   source                              = "git::https://github.com/t-dever/public-reusable-aviatrix-terraform-modules//modules/aviatrix/controller_initialize?ref=v2.3.3"
#   aviatrix_controller_public_ip       = aws_eip.aviatrix_controller_eip.public_ip
#   aviatrix_controller_private_ip      = local.controller_private_ip
#   aviatrix_controller_password        = random_password.aviatrix_controller_password.result
#   aviatrix_controller_admin_email     = var.aviatrix_controller_admin_email
#   aviatrix_controller_version         = var.aviatrix_controller_version
#   aviatrix_controller_customer_id     = var.aviatrix_controller_customer_id
#   aviatrix_aws_primary_account_name   = var.aviatrix_aws_primary_account_name
#   aviatrix_aws_primary_account_number = data.aws_caller_identity.current.account_id
#   aviatrix_aws_role_app_arn           = aws_iam_role.aviatrix_role_app.arn
#   aviatrix_aws_role_ec2_arn           = aws_iam_role.aviatrix_role_ec2.arn
#   enable_security_group_management    = var.enable_auto_aviatrix_controller_security_group_mgmt
#   aws_gov                             = local.is_aws_gov
#   copilot_username                    = var.deploy_aviatrix_copilot ? var.aviatrix_copilot_username : ""
#   copilot_password                    = var.deploy_aviatrix_copilot ? random_password.aviatrix_copilot_password[0].result : ""
# }

# # Creates CoPilot Public IP Address
# resource "aws_eip" "aviatrix_copilot_eip" {
#   count = var.deploy_aviatrix_copilot ? 1 : 0
#   vpc   = true
#   tags  = { "Name" = "${var.tag_prefix}-copilot-eip" }
# }

# # Get's the Aviatrix Gateways IP addresses from the Aviatrix Controller Security Groups.
# data "external" "get_aviatrix_gateway_cidrs" {
#   count = var.deploy_aviatrix_copilot && var.enable_auto_aviatrix_copilot_security_group ? 1 : 0
#   depends_on = [
#     module.aviatrix_controller_initialize
#   ]
#   program = ["python3", "${path.module}/get_security_group_rules.py"]
#   query = {
#     region = "${var.region}"
#     vpc_id = "${aws_vpc.vpc.id}"
#   }
# }

# # Creates Aviatrix Copilot Security Group
# resource "aws_security_group" "aviatrix_copilot_security_group" {
#   count       = var.deploy_aviatrix_copilot ? 1 : 0
#   name        = var.aviatrix_copilot_security_group_name
#   description = "Aviatrix - CoPilot Security Group"
#   vpc_id      = aws_vpc.vpc.id
#   tags        = { "Name" = var.aviatrix_copilot_security_group_name }
# }

# # Creates Egress Rule to allow internet traffic for the Aviatrix CoPilot
# resource "aws_security_group_rule" "aviatrix_copilot_security_group_egress_rule" {
#   count             = var.deploy_aviatrix_copilot ? 1 : 0
#   description       = "Allow default route outbound to internet."
#   type              = "egress"
#   from_port         = 0
#   to_port           = 0
#   protocol          = "-1"
#   cidr_blocks       = ["0.0.0.0/0"]
#   security_group_id = aws_security_group.aviatrix_copilot_security_group[0].id
# }

# # Creates Ingress Rule to allow user public IP addresses for the Aviatrix CoPilot
# resource "aws_security_group_rule" "aviatrix_copilot_security_group_ingress_rule" {
#   count             = var.deploy_aviatrix_copilot ? 1 : 0
#   description       = "Allow User Assigned IP addresses inbound to Aviatrix CoPilot."
#   type              = "ingress"
#   from_port         = 443
#   to_port           = 443
#   protocol          = "tcp"
#   cidr_blocks       = var.allowed_ips
#   security_group_id = aws_security_group.aviatrix_copilot_security_group[0].id
# }

# # Creates Ingress Rule to allow Aviatrix Gateways Syslog Access to CoPilot
# resource "aws_security_group_rule" "aviatrix_copilot_security_group_ingress_gateways_syslog_rule" {
#   count             = var.deploy_aviatrix_copilot && var.enable_auto_aviatrix_copilot_security_group ? 1 : 0
#   description       = "Allow Gateways access to send Rsyslog to Aviatrix CoPilot."
#   type              = "ingress"
#   from_port         = 5000
#   to_port           = 5000
#   protocol          = "udp"
#   cidr_blocks       = local.copilot_security_group_ips
#   security_group_id = aws_security_group.aviatrix_copilot_security_group[0].id
# }

# # Creates Ingress Rule to allow Aviatrix Gateways Flow Logs Access to CoPilot
# resource "aws_security_group_rule" "aviatrix_copilot_security_group_ingress_gateways_flow_logs_rule" {
#   count             = var.deploy_aviatrix_copilot && var.enable_auto_aviatrix_copilot_security_group ? 1 : 0
#   description       = "Allow Gateways access to send Flow Logs to Aviatrix CoPilot."
#   type              = "ingress"
#   from_port         = 31283
#   to_port           = 31283
#   protocol          = "udp"
#   cidr_blocks       = local.copilot_security_group_ips
#   security_group_id = aws_security_group.aviatrix_copilot_security_group[0].id
# }

# # Creates CoPilot Network Interface
# resource "aws_network_interface" "aviatrix_copilot_network_interface" {
#   count           = var.deploy_aviatrix_copilot ? 1 : 0
#   subnet_id       = aws_subnet.aviatrix_copilot_subnet[0].id
#   security_groups = [aws_security_group.aviatrix_copilot_security_group[0].id]
#   private_ips     = [local.copilot_private_ip]
#   tags            = { "Name" = "${var.tag_prefix}-copilot-eni" }
#   lifecycle {
#     ignore_changes = [tags, security_groups, subnet_id]
#   }
# }

# # Creates CoPilot Instance
# resource "aws_instance" "aviatrix_copilot_instance" {
#   count         = var.deploy_aviatrix_copilot ? 1 : 0
#   ami           = local.copilot_ami_id
#   instance_type = var.aviatrix_copilot_instance_size
#   key_name      = aws_key_pair.key_pair.key_name
#   monitoring    = true
#   ebs_optimized = true

#   metadata_options {
#     http_endpoint = "enabled"
#     http_tokens   = "required"
#   }

#   network_interface {
#     network_interface_id = aws_network_interface.aviatrix_copilot_network_interface[0].id
#     device_index         = 0
#   }

#   root_block_device {
#     encrypted   = true
#     volume_size = var.aviatrix_copilot_root_volume_size
#     volume_type = var.aviatrix_copilot_root_volume_type
#   }

#   tags = { "Name" = var.aviatrix_copilot_name }
# }

# # Associates Public IP Address to Aviatrix CoPilot Instance.
# resource "aws_eip_association" "aviatrix_copilot_eip_assoc" {
#   count         = var.deploy_aviatrix_copilot ? 1 : 0
#   instance_id   = aws_instance.aviatrix_copilot_instance[0].id
#   allocation_id = aws_eip.aviatrix_copilot_eip[0].id
# }

# # Creates EBS volumes
# resource "aws_ebs_volume" "aviatrix_copilot_ebs_volumes" {
#   #checkov:skip=CKV_AWS_189:Ensure EBS Volume is encrypted by KMS using a customer managed Key (CMK)
#   #checkov:skip=CKV2_AWS_9:Ensure that EBS are added in the backup plans of AWS Backup
#   count             = var.deploy_aviatrix_copilot ? length(var.aviatrix_copilot_additional_volumes) : 0
#   availability_zone = var.aviatrix_copilot_subnet.availability_zone
#   size              = var.aviatrix_copilot_additional_volumes[count.index].size
#   encrypted         = true
# }

# # Attaches extra volumes to CoPilot Instance
# resource "aws_volume_attachment" "aviatrix_copilot_ebs_attach" {
#   count       = var.deploy_aviatrix_copilot ? length(var.aviatrix_copilot_additional_volumes) : 0
#   device_name = "/dev/sd${substr(local.additonal_volumes_lettering, count.index, 1)}"
#   volume_id   = aws_ebs_volume.aviatrix_copilot_ebs_volumes[count.index].id
#   instance_id = aws_instance.aviatrix_copilot_instance[0].id
# }

