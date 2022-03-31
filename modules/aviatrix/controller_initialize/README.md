<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_null"></a> [null](#requirement\_null) | 3.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_null"></a> [null](#provider\_null) | 3.1.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [null_resource.initial_config](https://registry.terraform.io/providers/hashicorp/null/3.1.0/docs/resources/resource) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aviatrix_aws_primary_account_name"></a> [aviatrix\_aws\_primary\_account\_name](#input\_aviatrix\_aws\_primary\_account\_name) | The AWS Primary Account name to be added to the Aviatrix Controller Access Accounts. | `string` | `""` | no |
| <a name="input_aviatrix_aws_primary_account_number"></a> [aviatrix\_aws\_primary\_account\_number](#input\_aviatrix\_aws\_primary\_account\_number) | The AWS Account Number to be used with the primary AWS account. | `string` | `""` | no |
| <a name="input_aviatrix_aws_role_app_arn"></a> [aviatrix\_aws\_role\_app\_arn](#input\_aviatrix\_aws\_role\_app\_arn) | The AWS role app ARN for the primary AWS account. | `string` | `""` | no |
| <a name="input_aviatrix_aws_role_ec2_arn"></a> [aviatrix\_aws\_role\_ec2\_arn](#input\_aviatrix\_aws\_role\_ec2\_arn) | The AWS role ec2 ARN for the primary AWS account. | `string` | `""` | no |
| <a name="input_aviatrix_azure_primary_account_client_id"></a> [aviatrix\_azure\_primary\_account\_client\_id](#input\_aviatrix\_azure\_primary\_account\_client\_id) | The Azure Primary Account Client ID to be added to the Aviatrix Controller Access Accounts. | `string` | `""` | no |
| <a name="input_aviatrix_azure_primary_account_client_secret"></a> [aviatrix\_azure\_primary\_account\_client\_secret](#input\_aviatrix\_azure\_primary\_account\_client\_secret) | The Azure Primary Account Client Secret to be added to the Aviatrix Controller Access Accounts. | `string` | `""` | no |
| <a name="input_aviatrix_azure_primary_account_name"></a> [aviatrix\_azure\_primary\_account\_name](#input\_aviatrix\_azure\_primary\_account\_name) | The Azure Primary Account name to be added to the Aviatrix Controller Access Accounts. | `string` | `""` | no |
| <a name="input_aviatrix_azure_primary_account_subscription_id"></a> [aviatrix\_azure\_primary\_account\_subscription\_id](#input\_aviatrix\_azure\_primary\_account\_subscription\_id) | The Azure Primary Account Subscription ID to be added to the Aviatrix Controller Access Accounts. | `string` | `""` | no |
| <a name="input_aviatrix_azure_primary_account_tenant_id"></a> [aviatrix\_azure\_primary\_account\_tenant\_id](#input\_aviatrix\_azure\_primary\_account\_tenant\_id) | The Azure Primary Account Tenant ID to be added to the Aviatrix Controller Access Accounts. | `string` | `""` | no |
| <a name="input_aviatrix_controller_admin_email"></a> [aviatrix\_controller\_admin\_email](#input\_aviatrix\_controller\_admin\_email) | The administrator email address to be added to the admin user in the Aviatrix Controller | `string` | n/a | yes |
| <a name="input_aviatrix_controller_customer_id"></a> [aviatrix\_controller\_customer\_id](#input\_aviatrix\_controller\_customer\_id) | The license/customer id for the Aviatrix Controller. | `string` | n/a | yes |
| <a name="input_aviatrix_controller_password"></a> [aviatrix\_controller\_password](#input\_aviatrix\_controller\_password) | The password to be added to the admin account of the Aviatrix Controller | `string` | n/a | yes |
| <a name="input_aviatrix_controller_private_ip"></a> [aviatrix\_controller\_private\_ip](#input\_aviatrix\_controller\_private\_ip) | The Private IP Address of the Aviatrix Controller. | `string` | n/a | yes |
| <a name="input_aviatrix_controller_public_ip"></a> [aviatrix\_controller\_public\_ip](#input\_aviatrix\_controller\_public\_ip) | The Public IP Address of the Aviatrix Controller. | `string` | n/a | yes |
| <a name="input_aviatrix_controller_version"></a> [aviatrix\_controller\_version](#input\_aviatrix\_controller\_version) | The version of the Aviatrix Controller. | `string` | n/a | yes |
| <a name="input_aws_gov"></a> [aws\_gov](#input\_aws\_gov) | If using AWS Gov set to true. | `bool` | `false` | no |
| <a name="input_copilot_password"></a> [copilot\_password](#input\_copilot\_password) | Password of Copilot Account; Adds a account for CoPilot with ReadOnly Credentials. Must Provide variables 'copilot\_username' and 'copilot\_password' | `string` | `""` | no |
| <a name="input_copilot_username"></a> [copilot\_username](#input\_copilot\_username) | Username of Copilot Account; Adds a account for CoPilot with ReadOnly Credentials. Must Provide variables 'copilot\_username' and 'copilot\_password' | `string` | `""` | no |
| <a name="input_enable_security_group_management"></a> [enable\_security\_group\_management](#input\_enable\_security\_group\_management) | Enables Auto Security Group Management within the Aviatrix Controller. A primary access account is required for implementation. | `bool` | `true` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->