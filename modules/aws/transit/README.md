<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aviatrix"></a> [aviatrix](#requirement\_aviatrix) | 2.21.2 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 4.4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aviatrix"></a> [aviatrix](#provider\_aviatrix) | 2.21.2 |
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.4.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_palo_alto_bootstrap"></a> [palo\_alto\_bootstrap](#module\_palo\_alto\_bootstrap) | ./firewalls/palo_alto | n/a |

## Resources

| Name | Type |
|------|------|
| [aviatrix_firenet.firenet](https://registry.terraform.io/providers/AviatrixSystems/aviatrix/2.21.2/docs/resources/firenet) | resource |
| [aviatrix_transit_gateway.aviatrix_transit_gateway](https://registry.terraform.io/providers/AviatrixSystems/aviatrix/2.21.2/docs/resources/transit_gateway) | resource |
| [aws_default_security_group.default_security_group](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/default_security_group) | resource |
| [aws_internet_gateway.vpc_internet_gateway](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/internet_gateway) | resource |
| [aws_network_interface_sg_attachment.palo_attach_firewall_mgmt_security_group](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/network_interface_sg_attachment) | resource |
| [aws_route.internet_route](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/route) | resource |
| [aws_route_table.vpc_route_table](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/route_table) | resource |
| [aws_route_table_association.aviatrix_firewall_egress_ha_route_table_assoc](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/route_table_association) | resource |
| [aws_route_table_association.aviatrix_firewall_egress_primary_route_table_assoc](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/route_table_association) | resource |
| [aws_route_table_association.aviatrix_firewall_mgmt_ha_route_table_assoc](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/route_table_association) | resource |
| [aws_route_table_association.aviatrix_firewall_mgmt_primary_route_table_assoc](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/route_table_association) | resource |
| [aws_route_table_association.aviatrix_transit_ha_route_table_assoc](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/route_table_association) | resource |
| [aws_route_table_association.aviatrix_transit_primary_route_table_assoc](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/route_table_association) | resource |
| [aws_security_group.aviatrix_firewall_mgmt_security_group](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/security_group) | resource |
| [aws_security_group_rule.aviatrix_firewall_mgmt_ingress_https_user_public_ips](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/security_group_rule) | resource |
| [aws_subnet.aviatrix_firewall_egress_ha_subnet](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/subnet) | resource |
| [aws_subnet.aviatrix_firewall_egress_primary_subnet](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/subnet) | resource |
| [aws_subnet.aviatrix_firewall_mgmt_ha_subnet](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/subnet) | resource |
| [aws_subnet.aviatrix_firewall_mgmt_primary_subnet](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/subnet) | resource |
| [aws_subnet.aviatrix_transit_ha_subnet](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/subnet) | resource |
| [aws_subnet.aviatrix_transit_primary_subnet](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/subnet) | resource |
| [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/vpc) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aviatrix_access_account_name"></a> [aviatrix\_access\_account\_name](#input\_aviatrix\_access\_account\_name) | The name of the access account to be used in the Aviatrix Controller for deployment of Transit Gateways. | `string` | n/a | yes |
| <a name="input_aviatrix_firewall_egress_ha_subnet_name"></a> [aviatrix\_firewall\_egress\_ha\_subnet\_name](#input\_aviatrix\_firewall\_egress\_ha\_subnet\_name) | The name of the HA Firewall Egress Subnet. | `string` | `"aviatrix-firewall-egress-ha"` | no |
| <a name="input_aviatrix_firewall_egress_primary_subnet_name"></a> [aviatrix\_firewall\_egress\_primary\_subnet\_name](#input\_aviatrix\_firewall\_egress\_primary\_subnet\_name) | The name of the Primary Firewall Egress Subnet. | `string` | `"aviatrix-firewall-egress-primary"` | no |
| <a name="input_aviatrix_firewall_mgmt_ha_subnet_name"></a> [aviatrix\_firewall\_mgmt\_ha\_subnet\_name](#input\_aviatrix\_firewall\_mgmt\_ha\_subnet\_name) | The name of the HA Firewall Management Subnet. | `string` | `"aviatrix-firewall-mgmt-ha"` | no |
| <a name="input_aviatrix_firewall_mgmt_primary_subnet_name"></a> [aviatrix\_firewall\_mgmt\_primary\_subnet\_name](#input\_aviatrix\_firewall\_mgmt\_primary\_subnet\_name) | The name of the Primary Firewall Management Subnet. | `string` | `"aviatrix-firewall-mgmt-primary"` | no |
| <a name="input_aviatrix_transit_availability_zone_1"></a> [aviatrix\_transit\_availability\_zone\_1](#input\_aviatrix\_transit\_availability\_zone\_1) | The availability zone for Primary Aviatrix Transit Gateway | `string` | `"us-east-1a"` | no |
| <a name="input_aviatrix_transit_availability_zone_2"></a> [aviatrix\_transit\_availability\_zone\_2](#input\_aviatrix\_transit\_availability\_zone\_2) | The availability zone for HA Aviatrix Transit Gateway | `string` | `"us-east-1b"` | no |
| <a name="input_aviatrix_transit_gateway_name"></a> [aviatrix\_transit\_gateway\_name](#input\_aviatrix\_transit\_gateway\_name) | The name used for the transit gateway resource | `string` | `"aviatrix-transit-gw"` | no |
| <a name="input_aviatrix_transit_gateway_size"></a> [aviatrix\_transit\_gateway\_size](#input\_aviatrix\_transit\_gateway\_size) | The size of the transit gateways | `string` | `"t2.large"` | no |
| <a name="input_aviatrix_transit_ha_subnet_name"></a> [aviatrix\_transit\_ha\_subnet\_name](#input\_aviatrix\_transit\_ha\_subnet\_name) | The name of the HA Aviatrix Transit Gateway Subnet. | `string` | `"aviatrix-transit-ha"` | no |
| <a name="input_aviatrix_transit_primary_subnet_name"></a> [aviatrix\_transit\_primary\_subnet\_name](#input\_aviatrix\_transit\_primary\_subnet\_name) | The name of the Primary Aviatrix Transit Gateway Subnet. | `string` | `"aviatrix-transit-primary"` | no |
| <a name="input_controller_password"></a> [controller\_password](#input\_controller\_password) | The controllers password. | `string` | n/a | yes |
| <a name="input_controller_public_ip"></a> [controller\_public\_ip](#input\_controller\_public\_ip) | The controllers public IP address. | `string` | `"1.2.3.4"` | no |
| <a name="input_controller_username"></a> [controller\_username](#input\_controller\_username) | The controllers username. | `string` | `"admin"` | no |
| <a name="input_deploy_palo_alto_firewalls"></a> [deploy\_palo\_alto\_firewalls](#input\_deploy\_palo\_alto\_firewalls) | All of the attributes to deploy Palo Alto Firewalls | <pre>object({<br>    s3_bucket_name                 = string,<br>    s3_iam_role_name               = string,<br>    aws_key_pair_public_key        = string,<br>    aws_firewall_key_pair_name     = string,<br>    firewall_private_key_location  = string,<br>    firewall_password              = string,<br>    store_firewall_password_in_ssm = bool,<br>    firewalls = list(object({<br>      name = string<br>    }))<br>    firewall_image         = string,<br>    firewall_image_version = string,<br>    firewall_size          = string<br>  })</pre> | `null` | no |
| <a name="input_enable_aviatrix_transit_firenet"></a> [enable\_aviatrix\_transit\_firenet](#input\_enable\_aviatrix\_transit\_firenet) | Enables firenet on the aviatrix transit gateway | `bool` | `false` | no |
| <a name="input_enable_aviatrix_transit_gateway_ha"></a> [enable\_aviatrix\_transit\_gateway\_ha](#input\_enable\_aviatrix\_transit\_gateway\_ha) | Enable High Availability (HA) for transit gateways | `bool` | `false` | no |
| <a name="input_enable_firenet_egress"></a> [enable\_firenet\_egress](#input\_enable\_firenet\_egress) | Allow traffic to the internet through firewall. | `bool` | `false` | no |
| <a name="input_firewall_allowed_ips"></a> [firewall\_allowed\_ips](#input\_firewall\_allowed\_ips) | List of allowed User Public Ips to be added as ingress rule for security group. | `list(string)` | `[]` | no |
| <a name="input_firewall_mgmt_security_group_name"></a> [firewall\_mgmt\_security\_group\_name](#input\_firewall\_mgmt\_security\_group\_name) | The name of the Security Group for Firewall Management. | `string` | `"aviatrix-firewall-mgmt-security-group"` | no |
| <a name="input_insane_mode"></a> [insane\_mode](#input\_insane\_mode) | Enable insane mode for transit gateway. | `bool` | `false` | no |
| <a name="input_region"></a> [region](#input\_region) | The region where the resources will be deployed. | `string` | `"us-east-1"` | no |
| <a name="input_tag_prefix"></a> [tag\_prefix](#input\_tag\_prefix) | The prefix of tagged resource names. | `string` | `"aviatrix"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | The tags used for resources. | `map(any)` | `{}` | no |
| <a name="input_vpc_address_space"></a> [vpc\_address\_space](#input\_vpc\_address\_space) | The address space used for the VPC. | `string` | `"10.0.0.0/23"` | no |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | The name of the VPC. | `string` | `"aviatrix-transit-vpc"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->