<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 4.4.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | 3.1.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.4.0 |
| <a name="provider_external"></a> [external](#provider\_external) | n/a |
| <a name="provider_http"></a> [http](#provider\_http) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | 3.1.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aviatrix_controller_initialize"></a> [aviatrix\_controller\_initialize](#module\_aviatrix\_controller\_initialize) | git::https://github.com/t-dever/public-reusable-aviatrix-terraform-modules//modules/aviatrix/controller_initialize | improveAwsController |

## Resources

| Name | Type |
|------|------|
| [aws_default_security_group.default_security_group](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/default_security_group) | resource |
| [aws_eip.aviatrix_controller_eip](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/eip) | resource |
| [aws_eip.aviatrix_copilot_eip](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/eip) | resource |
| [aws_eip_association.aviatrix_controller_eip_assoc](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/eip_association) | resource |
| [aws_eip_association.aviatrix_copilot_eip_assoc](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/eip_association) | resource |
| [aws_iam_instance_profile.aviatrix_role_ec2_profile](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/iam_instance_profile) | resource |
| [aws_iam_policy.aviatrix_app_policy](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/iam_policy) | resource |
| [aws_iam_policy.aviatrix_assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/iam_policy) | resource |
| [aws_iam_role.aviatrix_role_app](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/iam_role) | resource |
| [aws_iam_role.aviatrix_role_ec2](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.aviatrix_role_app_attach](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.aviatrix_role_ec2_attach](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_instance.aviatrix_controller_instance](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/instance) | resource |
| [aws_instance.aviatrix_copilot_instance](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/instance) | resource |
| [aws_internet_gateway.vpc_internet_gateway](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/internet_gateway) | resource |
| [aws_key_pair.key_pair](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/key_pair) | resource |
| [aws_network_interface.aviatrix_controller_network_interface](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/network_interface) | resource |
| [aws_network_interface.aviatrix_copilot_network_interface](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/network_interface) | resource |
| [aws_route.internet_route](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/route) | resource |
| [aws_route_table.vpc_route_table](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/route_table) | resource |
| [aws_route_table_association.aviatrix_controller_route_table_assoc](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/route_table_association) | resource |
| [aws_route_table_association.aviatrix_copilot_route_table_assoc](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/route_table_association) | resource |
| [aws_security_group.aviatrix_controller_security_group](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/security_group) | resource |
| [aws_security_group.aviatrix_copilot_security_group](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/security_group) | resource |
| [aws_security_group_rule.aviatrix_controller_security_group_egress_rule](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.aviatrix_controller_security_group_ingress_allow_copilot](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.aviatrix_controller_security_group_ingress_rule](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.aviatrix_copilot_security_group_egress_rule](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.aviatrix_copilot_security_group_ingress_gateways_flow_logs_rule](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.aviatrix_copilot_security_group_ingress_gateways_syslog_rule](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.aviatrix_copilot_security_group_ingress_rule](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/security_group_rule) | resource |
| [aws_ssm_parameter.aviatrix_controller_secret_parameter](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/ssm_parameter) | resource |
| [aws_subnet.additional_subnets](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/subnet) | resource |
| [aws_subnet.aviatrix_controller_subnet](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/subnet) | resource |
| [aws_subnet.aviatrix_copilot_subnet](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/subnet) | resource |
| [aws_volume_attachment.aviatrix_copilot_ebs_attach](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/volume_attachment) | resource |
| [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/vpc) | resource |
| [random_password.aviatrix_controller_password](https://registry.terraform.io/providers/hashicorp/random/3.1.0/docs/resources/password) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/data-sources/region) | data source |
| [external_external.get_aviatrix_gateway_cidrs](https://registry.terraform.io/providers/hashicorp/external/latest/docs/data-sources/external) | data source |
| [http_http.aviatrix_controller_iam_id](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |
| [http_http.aviatrix_copilot_iam_id](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_subnets"></a> [additional\_subnets](#input\_additional\_subnets) | The subnets to be created. | <pre>map(object({<br>    cidr_block        = string,<br>    availability_zone = string<br>  }))</pre> | `{}` | no |
| <a name="input_allowed_ips"></a> [allowed\_ips](#input\_allowed\_ips) | List of allowed ips to be added as ingress rule for security group. | `list(string)` | `[]` | no |
| <a name="input_arn_partition"></a> [arn\_partition](#input\_arn\_partition) | The value used in ARN ID. | `string` | `"aws"` | no |
| <a name="input_aviatrix_app_policy_name"></a> [aviatrix\_app\_policy\_name](#input\_aviatrix\_app\_policy\_name) | n/a | `string` | `"aviatrix-role-app-policy"` | no |
| <a name="input_aviatrix_assume_policy_role_policy_name"></a> [aviatrix\_assume\_policy\_role\_policy\_name](#input\_aviatrix\_assume\_policy\_role\_policy\_name) | n/a | `string` | `"aviatrix-role-ec2-assume-role-policy"` | no |
| <a name="input_aviatrix_aws_primary_account_name"></a> [aviatrix\_aws\_primary\_account\_name](#input\_aviatrix\_aws\_primary\_account\_name) | The primary account name to be added to the aviatrix access accounts. | `string` | `"aviatrix-aws-primary-account"` | no |
| <a name="input_aviatrix_controller_admin_email"></a> [aviatrix\_controller\_admin\_email](#input\_aviatrix\_controller\_admin\_email) | The administrators email address for initial controller provisioning. | `string` | n/a | yes |
| <a name="input_aviatrix_controller_customer_id"></a> [aviatrix\_controller\_customer\_id](#input\_aviatrix\_controller\_customer\_id) | The customer id for the aviatrix controller | `string` | n/a | yes |
| <a name="input_aviatrix_controller_instance_size"></a> [aviatrix\_controller\_instance\_size](#input\_aviatrix\_controller\_instance\_size) | Aviatrix Controller instance size. | `string` | `"t3.large"` | no |
| <a name="input_aviatrix_controller_name"></a> [aviatrix\_controller\_name](#input\_aviatrix\_controller\_name) | Name of controller that will be launched. | `string` | `"aviatrix-controller"` | no |
| <a name="input_aviatrix_controller_root_volume_size"></a> [aviatrix\_controller\_root\_volume\_size](#input\_aviatrix\_controller\_root\_volume\_size) | Root volume disk size for controller | `number` | `32` | no |
| <a name="input_aviatrix_controller_root_volume_type"></a> [aviatrix\_controller\_root\_volume\_type](#input\_aviatrix\_controller\_root\_volume\_type) | Root volume type for controller | `string` | `"gp2"` | no |
| <a name="input_aviatrix_controller_security_group_name"></a> [aviatrix\_controller\_security\_group\_name](#input\_aviatrix\_controller\_security\_group\_name) | The name of the security group for the Aviatrix Controller. | `string` | `"aviatrix-controller-security-group"` | no |
| <a name="input_aviatrix_controller_subnet"></a> [aviatrix\_controller\_subnet](#input\_aviatrix\_controller\_subnet) | The aviatrix controller subnet to be created. | <pre>object({<br>    name              = string,<br>    cidr_block        = string,<br>    availability_zone = string<br>  })</pre> | <pre>{<br>  "availability_zone": "us-east-1a",<br>  "cidr_block": "10.0.0.0/26",<br>  "name": "aviatrix-controller"<br>}</pre> | no |
| <a name="input_aviatrix_controller_version"></a> [aviatrix\_controller\_version](#input\_aviatrix\_controller\_version) | The version used for the controller | `string` | `"6.6"` | no |
| <a name="input_aviatrix_copilot_additional_volumes"></a> [aviatrix\_copilot\_additional\_volumes](#input\_aviatrix\_copilot\_additional\_volumes) | Additonal volumes to add to CoPilot. | <pre>map(object({<br>    device_name = string,<br>    volume_id   = string,<br>  }))</pre> | `{}` | no |
| <a name="input_aviatrix_copilot_instance_size"></a> [aviatrix\_copilot\_instance\_size](#input\_aviatrix\_copilot\_instance\_size) | Aviatrix CoPilot instance size. | `string` | `"t3.2xlarge"` | no |
| <a name="input_aviatrix_copilot_name"></a> [aviatrix\_copilot\_name](#input\_aviatrix\_copilot\_name) | Name of copilot that will be launched. | `string` | `"aviatrix-copilot"` | no |
| <a name="input_aviatrix_copilot_root_volume_size"></a> [aviatrix\_copilot\_root\_volume\_size](#input\_aviatrix\_copilot\_root\_volume\_size) | Root volume size for copilot | `number` | `25` | no |
| <a name="input_aviatrix_copilot_root_volume_type"></a> [aviatrix\_copilot\_root\_volume\_type](#input\_aviatrix\_copilot\_root\_volume\_type) | Root volume type for copilot | `string` | `"gp2"` | no |
| <a name="input_aviatrix_copilot_security_group_name"></a> [aviatrix\_copilot\_security\_group\_name](#input\_aviatrix\_copilot\_security\_group\_name) | The name of the security group for the Aviatrix CoPilot. | `string` | `"aviatrix-copilot-security-group"` | no |
| <a name="input_aviatrix_copilot_subnet"></a> [aviatrix\_copilot\_subnet](#input\_aviatrix\_copilot\_subnet) | The aviatrix copilot subnet to be created. | <pre>object({<br>    name              = string,<br>    cidr_block        = string,<br>    availability_zone = string<br>  })</pre> | <pre>{<br>  "availability_zone": "us-east-1a",<br>  "cidr_block": "10.0.0.64/26",<br>  "name": "aviatrix-copilot"<br>}</pre> | no |
| <a name="input_aviatrix_role_app_name"></a> [aviatrix\_role\_app\_name](#input\_aviatrix\_role\_app\_name) | n/a | `string` | `"aviatrix-role-app"` | no |
| <a name="input_aviatrix_role_ec2_name"></a> [aviatrix\_role\_ec2\_name](#input\_aviatrix\_role\_ec2\_name) | n/a | `string` | `"aviatrix-role-ec2"` | no |
| <a name="input_aws_key_pair_name"></a> [aws\_key\_pair\_name](#input\_aws\_key\_pair\_name) | The key pair name to be used for EC2 Instance Deployments. | `string` | `"aviatrix-controller-key"` | no |
| <a name="input_aws_key_pair_public_key"></a> [aws\_key\_pair\_public\_key](#input\_aws\_key\_pair\_public\_key) | The key pair public ssh key to be used for EC2 Instance Deployments. | `string` | n/a | yes |
| <a name="input_enable_auto_aviatrix_copilot_security_group"></a> [enable\_auto\_aviatrix\_copilot\_security\_group](#input\_enable\_auto\_aviatrix\_copilot\_security\_group) | Turns on the script for collecting the gateway IP addresses from the security groups of the Aviatrix Controller. Then applies them to copilot security group. | `bool` | `false` | no |
| <a name="input_region"></a> [region](#input\_region) | The region where the resources will be deployed. | `string` | `"us-east-1"` | no |
| <a name="input_tag_prefix"></a> [tag\_prefix](#input\_tag\_prefix) | The prefix of tagged resource names. | `string` | `"aviatrix"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | The tags used for resources. | `map(any)` | `{}` | no |
| <a name="input_vpc_address_space"></a> [vpc\_address\_space](#input\_vpc\_address\_space) | The address space used for the VPC. | `string` | `"10.0.0.0/24"` | no |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | The name of the VPC. | `string` | `"aviatrix-controller-vpc"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aviatrix_controller_private_ip"></a> [aviatrix\_controller\_private\_ip](#output\_aviatrix\_controller\_private\_ip) | The Aviatrix Controllers private IP Address. |
| <a name="output_aviatrix_controller_public_ip"></a> [aviatrix\_controller\_public\_ip](#output\_aviatrix\_controller\_public\_ip) | The Aviatrix Controllers public IP Address. |
| <a name="output_aviatrix_copilot_private_ip"></a> [aviatrix\_copilot\_private\_ip](#output\_aviatrix\_copilot\_private\_ip) | The Aviatrix CoPilot private IP Address. |
| <a name="output_aviatrix_copilot_public_ip"></a> [aviatrix\_copilot\_public\_ip](#output\_aviatrix\_copilot\_public\_ip) | The Aviatrix CoPilot public IP Address. |
| <a name="output_aviatrix_gateway_cidrs"></a> [aviatrix\_gateway\_cidrs](#output\_aviatrix\_gateway\_cidrs) | Gateway Cidrs found on Aviatrix Controller Security Groups |
| <a name="output_aws_app_role_arn"></a> [aws\_app\_role\_arn](#output\_aws\_app\_role\_arn) | The ARN for the app role created. |
| <a name="output_aws_ec2_role_arn"></a> [aws\_ec2\_role\_arn](#output\_aws\_ec2\_role\_arn) | The ARN for the ec2 role created. |
<!-- END_TF_DOCS -->