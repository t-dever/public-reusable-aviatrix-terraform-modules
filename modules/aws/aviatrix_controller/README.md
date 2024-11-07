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
| <a name="provider_http"></a> [http](#provider\_http) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | 3.1.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aviatrix_controller_initialize"></a> [aviatrix\_controller\_initialize](#module\_aviatrix\_controller\_initialize) | git::https://github.com/t-dever/public-reusable-aviatrix-terraform-modules//modules/aviatrix/controller_initialize | tags/v2.4.4 |

## Resources

| Name | Type |
|------|------|
| [aws_default_security_group.default_security_group](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/default_security_group) | resource |
| [aws_ebs_volume.copilot_ebs_volumes](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/ebs_volume) | resource |
| [aws_eip.controller_eip](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/eip) | resource |
| [aws_eip.copilot_eip](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/eip) | resource |
| [aws_eip_association.controller_eip_assoc](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/eip_association) | resource |
| [aws_eip_association.copilot_eip_assoc](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/eip_association) | resource |
| [aws_iam_instance_profile.aviatrix_role_ec2_profile](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/iam_instance_profile) | resource |
| [aws_iam_policy.aviatrix_app_policy](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/iam_policy) | resource |
| [aws_iam_policy.aviatrix_assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/iam_policy) | resource |
| [aws_iam_role.aviatrix_role_app](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/iam_role) | resource |
| [aws_iam_role.aviatrix_role_ec2](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.aviatrix_role_app_attach](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.aviatrix_role_ec2_attach](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_instance.controller_instance](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/instance) | resource |
| [aws_instance.copilot_instance](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/instance) | resource |
| [aws_internet_gateway.internet_gateway](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/internet_gateway) | resource |
| [aws_key_pair.key_pair](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/key_pair) | resource |
| [aws_network_interface.controller_network_interface](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/network_interface) | resource |
| [aws_network_interface.copilot_network_interface](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/network_interface) | resource |
| [aws_resourcegroups_group.resource_group](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/resourcegroups_group) | resource |
| [aws_route.internet_route](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/route) | resource |
| [aws_route_table.vpc_route_table](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/route_table) | resource |
| [aws_route_table_association.controller_subnet_route_table_assoc](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/route_table_association) | resource |
| [aws_route_table_association.copilot_subnet_route_table_assoc](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/route_table_association) | resource |
| [aws_security_group.controller_security_group](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/security_group) | resource |
| [aws_security_group.copilot_security_group](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/security_group) | resource |
| [aws_security_group_rule.controller_security_group_egress_rule_allow_internet](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.controller_security_group_ingress_rule_allow_copilot](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.controller_security_group_ingress_rule_allow_custom](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.copilot_security_group_egress_rule](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.copilot_security_group_ingress_rule_allow_controller](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.copilot_security_group_ingress_rule_allow_custom](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/security_group_rule) | resource |
| [aws_ssm_parameter.aviatrix_controller_secret_parameter](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.aviatrix_copilot_secret_parameter](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/ssm_parameter) | resource |
| [aws_subnet.additional_subnets](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/subnet) | resource |
| [aws_subnet.controller_subnet](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/subnet) | resource |
| [aws_subnet.copilot_subnet](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/subnet) | resource |
| [aws_volume_attachment.copilot_ebs_attach](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/volume_attachment) | resource |
| [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/vpc) | resource |
| [random_password.aviatrix_controller_password](https://registry.terraform.io/providers/hashicorp/random/3.1.0/docs/resources/password) | resource |
| [random_password.aviatrix_copilot_password](https://registry.terraform.io/providers/hashicorp/random/3.1.0/docs/resources/password) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/data-sources/caller_identity) | data source |
| [aws_key_pair.key_pair](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/data-sources/key_pair) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/data-sources/region) | data source |
| [http_http.aviatrix_controller_iam_id](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |
| [http_http.aviatrix_copilot_iam_id](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aviatrix_controller_admin_email"></a> [aviatrix\_controller\_admin\_email](#input\_aviatrix\_controller\_admin\_email) | The administrators email address for initial controller provisioning. | `string` | n/a | yes |
| <a name="input_aviatrix_controller_admin_password"></a> [aviatrix\_controller\_admin\_password](#input\_aviatrix\_controller\_admin\_password) | The Admin Password used for the Aviatrix Controller Login. | `string` | `""` | no |
| <a name="input_aviatrix_controller_aws_primary_account_name"></a> [aviatrix\_controller\_aws\_primary\_account\_name](#input\_aviatrix\_controller\_aws\_primary\_account\_name) | The primary account name to be added to the aviatrix access accounts. | `string` | `"aviatrix-aws-primary-account"` | no |
| <a name="input_aviatrix_controller_customer_id"></a> [aviatrix\_controller\_customer\_id](#input\_aviatrix\_controller\_customer\_id) | The customer id for the aviatrix controller | `string` | n/a | yes |
| <a name="input_aviatrix_controller_enable_auto_security_group_mgmt"></a> [aviatrix\_controller\_enable\_auto\_security\_group\_mgmt](#input\_aviatrix\_controller\_enable\_auto\_security\_group\_mgmt) | Enables auto security group management for the Aviatrix controller via the Controller Initialize script. | `bool` | `false` | no |
| <a name="input_aviatrix_controller_version"></a> [aviatrix\_controller\_version](#input\_aviatrix\_controller\_version) | The version used for the controller | `string` | `"6.6"` | no |
| <a name="input_aviatrix_copilot_password"></a> [aviatrix\_copilot\_password](#input\_aviatrix\_copilot\_password) | The password used for the Aviatrix Copilot Login. | `string` | `""` | no |
| <a name="input_aviatrix_copilot_username"></a> [aviatrix\_copilot\_username](#input\_aviatrix\_copilot\_username) | Username of Copilot Account; Adds a account for CoPilot with ReadOnly Credentials. Must Provide variables 'copilot\_username' and 'copilot\_password' | `string` | `"copilot-read-only"` | no |
| <a name="input_aws_additional_subnets"></a> [aws\_additional\_subnets](#input\_aws\_additional\_subnets) | The subnets to be created. | <pre>list(object({<br/>    name              = string,<br/>    cidr_block        = string,<br/>    availability_zone = string<br/>  }))</pre> | `[]` | no |
| <a name="input_aws_controller_eip_name"></a> [aws\_controller\_eip\_name](#input\_aws\_controller\_eip\_name) | The name of the Elastic IP Address for the Aviatrix Controller. | `string` | `"aviatrix-controller-eip"` | no |
| <a name="input_aws_controller_eni_name"></a> [aws\_controller\_eni\_name](#input\_aws\_controller\_eni\_name) | The name of the Network Interface for the Aviatrix Controller. | `string` | `"aviatrix-controller-eni"` | no |
| <a name="input_aws_controller_instance_size"></a> [aws\_controller\_instance\_size](#input\_aws\_controller\_instance\_size) | Aviatrix Controller instance size. | `string` | `"t3.large"` | no |
| <a name="input_aws_controller_name"></a> [aws\_controller\_name](#input\_aws\_controller\_name) | Name of controller that will be launched. | `string` | `"aviatrix-controller"` | no |
| <a name="input_aws_controller_root_volume_size"></a> [aws\_controller\_root\_volume\_size](#input\_aws\_controller\_root\_volume\_size) | Root volume disk size for controller | `number` | `32` | no |
| <a name="input_aws_controller_security_group_allowed_ips"></a> [aws\_controller\_security\_group\_allowed\_ips](#input\_aws\_controller\_security\_group\_allowed\_ips) | List of allowed ips to be added as ingress rule for Aviatrix Controller Security Group. | <pre>list(object({<br/>    description = string,<br/>    cidr_blocks = list(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_aws_controller_security_group_name"></a> [aws\_controller\_security\_group\_name](#input\_aws\_controller\_security\_group\_name) | The name of the security group for the Aviatrix Controller. | `string` | `"aviatrix-controller-security-group"` | no |
| <a name="input_aws_controller_subnet"></a> [aws\_controller\_subnet](#input\_aws\_controller\_subnet) | The aviatrix controller subnet to be created. | <pre>object({<br/>    name              = string,<br/>    cidr_block        = string,<br/>    availability_zone = string<br/>  })</pre> | <pre>{<br/>  "availability_zone": "us-east-1a",<br/>  "cidr_block": "10.0.0.0/26",<br/>  "name": "aviatrix-controller"<br/>}</pre> | no |
| <a name="input_aws_copilot_additional_volumes"></a> [aws\_copilot\_additional\_volumes](#input\_aws\_copilot\_additional\_volumes) | Additonal volumes to add to CoPilot. | <pre>list(object({<br/>    size = string<br/>  }))</pre> | <pre>[<br/>  {<br/>    "size": 50<br/>  }<br/>]</pre> | no |
| <a name="input_aws_copilot_deploy"></a> [aws\_copilot\_deploy](#input\_aws\_copilot\_deploy) | Deploys Aviatrix CoPilot with the Aviatrix Controller. | `bool` | `true` | no |
| <a name="input_aws_copilot_eip_name"></a> [aws\_copilot\_eip\_name](#input\_aws\_copilot\_eip\_name) | The name of the Elastic IP Address for the Aviatrix CoPilot. | `string` | `"aviatrix-copilot-eip"` | no |
| <a name="input_aws_copilot_eni_name"></a> [aws\_copilot\_eni\_name](#input\_aws\_copilot\_eni\_name) | The name of the Network Interface for the Aviatrix CoPilot. | `string` | `"aviatrix-copilot-eni"` | no |
| <a name="input_aws_copilot_instance_size"></a> [aws\_copilot\_instance\_size](#input\_aws\_copilot\_instance\_size) | Aviatrix CoPilot instance size. | `string` | `"t3.2xlarge"` | no |
| <a name="input_aws_copilot_name"></a> [aws\_copilot\_name](#input\_aws\_copilot\_name) | Name of controller that will be launched. | `string` | `"aviatrix-copilot"` | no |
| <a name="input_aws_copilot_root_volume_size"></a> [aws\_copilot\_root\_volume\_size](#input\_aws\_copilot\_root\_volume\_size) | Root volume disk size for controller | `number` | `25` | no |
| <a name="input_aws_copilot_security_group_allowed_ips"></a> [aws\_copilot\_security\_group\_allowed\_ips](#input\_aws\_copilot\_security\_group\_allowed\_ips) | List of allowed ips to be added as ingress rule for Aviatrix CoPilot Security Group. | <pre>list(object({<br/>    description = string,<br/>    cidr_blocks = list(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_aws_copilot_security_group_name"></a> [aws\_copilot\_security\_group\_name](#input\_aws\_copilot\_security\_group\_name) | The name of the security group for the Aviatrix CoPilot Instance. | `string` | `"aviatrix-copilot-security-group"` | no |
| <a name="input_aws_copilot_subnet"></a> [aws\_copilot\_subnet](#input\_aws\_copilot\_subnet) | The aviatrix copilot subnet to be created. | <pre>object({<br/>    name              = string,<br/>    cidr_block        = string,<br/>    availability_zone = string<br/>  })</pre> | <pre>{<br/>  "availability_zone": "us-east-1a",<br/>  "cidr_block": "10.0.0.64/26",<br/>  "name": "aviatrix-copilot"<br/>}</pre> | no |
| <a name="input_aws_iam_app_policy_name"></a> [aws\_iam\_app\_policy\_name](#input\_aws\_iam\_app\_policy\_name) | The name of the Aviatrix App Role Policy. | `string` | `"aviatrix-role-app-policy"` | no |
| <a name="input_aws_iam_assume_policy_role_policy_name"></a> [aws\_iam\_assume\_policy\_role\_policy\_name](#input\_aws\_iam\_assume\_policy\_role\_policy\_name) | The name of the Aviatrix Assume Role Policy. | `string` | `"aviatrix-role-ec2-assume-role-policy"` | no |
| <a name="input_aws_iam_role_app_name"></a> [aws\_iam\_role\_app\_name](#input\_aws\_iam\_role\_app\_name) | The name of the Aviatrix Role for App. | `string` | `"aviatrix-role-app"` | no |
| <a name="input_aws_iam_role_ec2_name"></a> [aws\_iam\_role\_ec2\_name](#input\_aws\_iam\_role\_ec2\_name) | The name of the Aviatrix Role for EC2. | `string` | `"aviatrix-role-ec2"` | no |
| <a name="input_aws_internet_gateway_name"></a> [aws\_internet\_gateway\_name](#input\_aws\_internet\_gateway\_name) | The name of the AWS Internet Gateway Tag. | `string` | `"aviatrix-internet-gateway"` | no |
| <a name="input_aws_key_pair_name"></a> [aws\_key\_pair\_name](#input\_aws\_key\_pair\_name) | The key pair name to be used for EC2 Instance Deployments. | `string` | `"aviatrix-controller-key"` | no |
| <a name="input_aws_key_pair_public_key"></a> [aws\_key\_pair\_public\_key](#input\_aws\_key\_pair\_public\_key) | The key pair public ssh key to be used for EC2 Instance Deployments. | `string` | `""` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The region where the resources will be deployed. | `string` | `"us-east-1"` | no |
| <a name="input_aws_resource_group_name"></a> [aws\_resource\_group\_name](#input\_aws\_resource\_group\_name) | The name of the resource group by key 'ownedBy'. | `string` | `"aviatrix-resource-group"` | no |
| <a name="input_aws_route_table_name"></a> [aws\_route\_table\_name](#input\_aws\_route\_table\_name) | The name of the Route Table Tag. | `string` | `"aviatrix-route-table"` | no |
| <a name="input_aws_store_credentials_in_ssm"></a> [aws\_store\_credentials\_in\_ssm](#input\_aws\_store\_credentials\_in\_ssm) | If enabled it will store credentials in AWS Systems Manager Parameter Store. | `bool` | `false` | no |
| <a name="input_aws_tags"></a> [aws\_tags](#input\_aws\_tags) | The tags used for resources. | `map(any)` | `{}` | no |
| <a name="input_aws_vpc_address_space"></a> [aws\_vpc\_address\_space](#input\_aws\_vpc\_address\_space) | The address space used for the VPC. | `string` | `"10.0.0.0/24"` | no |
| <a name="input_aws_vpc_name"></a> [aws\_vpc\_name](#input\_aws\_vpc\_name) | The name of the VPC. | `string` | `"aviatrix-controller-vpc"` | no |
| <a name="input_tag_prefix"></a> [tag\_prefix](#input\_tag\_prefix) | The prefix of tagged resource names; If used all resource names will have this appended to it. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aviatrix_controller_private_ip"></a> [aviatrix\_controller\_private\_ip](#output\_aviatrix\_controller\_private\_ip) | The Aviatrix Controllers private IP Address. |
| <a name="output_aviatrix_controller_public_ip"></a> [aviatrix\_controller\_public\_ip](#output\_aviatrix\_controller\_public\_ip) | The Aviatrix Controllers public IP Address. |
| <a name="output_aviatrix_copilot_private_ip"></a> [aviatrix\_copilot\_private\_ip](#output\_aviatrix\_copilot\_private\_ip) | The Aviatrix CoPilot private IP Address. |
| <a name="output_aviatrix_copilot_public_ip"></a> [aviatrix\_copilot\_public\_ip](#output\_aviatrix\_copilot\_public\_ip) | The Aviatrix CoPilot public IP Address. |
| <a name="output_aviatrix_primary_account_name"></a> [aviatrix\_primary\_account\_name](#output\_aviatrix\_primary\_account\_name) | The name of the aviatrix primary account to be provisioned in the controller. |
| <a name="output_aws_app_role_arn"></a> [aws\_app\_role\_arn](#output\_aws\_app\_role\_arn) | The ARN for the app role created. |
| <a name="output_aws_ec2_role_arn"></a> [aws\_ec2\_role\_arn](#output\_aws\_ec2\_role\_arn) | The ARN for the ec2 role created. |
| <a name="output_controller_admin_password"></a> [controller\_admin\_password](#output\_controller\_admin\_password) | The controller admin password |
<!-- END_TF_DOCS -->