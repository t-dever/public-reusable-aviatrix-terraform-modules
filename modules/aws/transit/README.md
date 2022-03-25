<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aviatrix"></a> [aviatrix](#requirement\_aviatrix) | 2.21.0-6.6.ga |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 4.4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aviatrix"></a> [aviatrix](#provider\_aviatrix) | 2.21.0-6.6.ga |
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.4.0 |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_palo_alto_bootstrap"></a> [palo\_alto\_bootstrap](#module\_palo\_alto\_bootstrap) | ./firewalls/palo_alto | n/a |

## Resources

| Name | Type |
|------|------|
| [aviatrix_firenet.firenet](https://registry.terraform.io/providers/AviatrixSystems/aviatrix/2.21.0-6.6.ga/docs/resources/firenet) | resource |
| [aviatrix_firewall_instance.firewall_instance](https://registry.terraform.io/providers/AviatrixSystems/aviatrix/2.21.0-6.6.ga/docs/resources/firewall_instance) | resource |
| [aviatrix_firewall_instance_association.firewall_instance_association](https://registry.terraform.io/providers/AviatrixSystems/aviatrix/2.21.0-6.6.ga/docs/resources/firewall_instance_association) | resource |
| [aviatrix_transit_gateway.aviatrix_transit_gateway](https://registry.terraform.io/providers/AviatrixSystems/aviatrix/2.21.0-6.6.ga/docs/resources/transit_gateway) | resource |
| [aws_default_security_group.default_security_group](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/default_security_group) | resource |
| [aws_internet_gateway.vpc_internet_gateway](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/internet_gateway) | resource |
| [aws_key_pair.key_pair](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/key_pair) | resource |
| [aws_network_interface_sg_attachment.attach_firewall_mgmt_security_group](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/network_interface_sg_attachment) | resource |
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
| [null_resource.initial_config](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [aviatrix_firenet_vendor_integration.vendor_integration](https://registry.terraform.io/providers/AviatrixSystems/aviatrix/2.21.0-6.6.ga/docs/data-sources/firenet_vendor_integration) | data source |

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
| <a name="input_enable_aviatrix_transit_firenet"></a> [enable\_aviatrix\_transit\_firenet](#input\_enable\_aviatrix\_transit\_firenet) | Enables firenet on the aviatrix transit gateway | `bool` | `false` | no |
| <a name="input_enable_aviatrix_transit_gateway_ha"></a> [enable\_aviatrix\_transit\_gateway\_ha](#input\_enable\_aviatrix\_transit\_gateway\_ha) | Enable High Availability (HA) for transit gateways | `bool` | `false` | no |
| <a name="input_enable_firenet_egress"></a> [enable\_firenet\_egress](#input\_enable\_firenet\_egress) | Allow traffic to the internet through firewall. | `bool` | `false` | no |
| <a name="input_firewall_allowed_ips"></a> [firewall\_allowed\_ips](#input\_firewall\_allowed\_ips) | List of allowed User Public Ips to be added as ingress rule for security group. | `list(string)` | `[]` | no |
| <a name="input_firewall_aws_key_pair_name"></a> [firewall\_aws\_key\_pair\_name](#input\_firewall\_aws\_key\_pair\_name) | The key pair name to be used for Firewall EC2 Instance Deployments. | `string` | `"aviatrix-firenet-key"` | no |
| <a name="input_firewall_image"></a> [firewall\_image](#input\_firewall\_image) | The firewall image to be used to deploy the NGFW's | `string` | `"Palo Alto Networks VM-Series Next-Generation Firewall Bundle 1"` | no |
| <a name="input_firewall_image_version"></a> [firewall\_image\_version](#input\_firewall\_image\_version) | The firewall image version specific to the NGFW vendor image | `string` | `"10.1.4"` | no |
| <a name="input_firewall_mgmt_security_group_name"></a> [firewall\_mgmt\_security\_group\_name](#input\_firewall\_mgmt\_security\_group\_name) | The name of the Security Group for Firewall Management. | `string` | `"aviatrix-firewall-mgmt-security-group"` | no |
| <a name="input_firewall_private_key_location"></a> [firewall\_private\_key\_location](#input\_firewall\_private\_key\_location) | The location of the private key on the local machine to authenticate to palo firewall to change admin credentials. | `string` | `""` | no |
| <a name="input_firewall_public_key"></a> [firewall\_public\_key](#input\_firewall\_public\_key) | The key pair public ssh key to be used for Firewall Instance Deployments. | `string` | `""` | no |
| <a name="input_firewalls"></a> [firewalls](#input\_firewalls) | The firewall instance information required for creating firewalls | <pre>list(object({<br>    name = string,<br>    size = string<br>  }))</pre> | `[]` | no |
| <a name="input_insane_mode"></a> [insane\_mode](#input\_insane\_mode) | Enable insane mode for transit gateway. | `bool` | `false` | no |
| <a name="input_region"></a> [region](#input\_region) | The region where the resources will be deployed. | `string` | `"us-east-1"` | no |
| <a name="input_s3_bucket_name"></a> [s3\_bucket\_name](#input\_s3\_bucket\_name) | The name of the S3 Bucket to store Firewall Bootstrap. | `string` | `""` | no |
| <a name="input_s3_iam_role_name"></a> [s3\_iam\_role\_name](#input\_s3\_iam\_role\_name) | The name of the iam role used to access S3 Bucket. | `string` | `"aviatrix-s3-bootstrap-role"` | no |
| <a name="input_tag_prefix"></a> [tag\_prefix](#input\_tag\_prefix) | The prefix of tagged resource names. | `string` | `"aviatrix"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | The tags used for resources. | `map(any)` | `{}` | no |
| <a name="input_vpc_address_space"></a> [vpc\_address\_space](#input\_vpc\_address\_space) | The address space used for the VPC. | `string` | `"10.0.0.0/23"` | no |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | The name of the VPC. | `string` | `"aviatrix-transit-vpc"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->