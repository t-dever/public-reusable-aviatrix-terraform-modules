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
| <a name="input_aviatrix_controller_admin_email"></a> [aviatrix\_controller\_admin\_email](#input\_aviatrix\_controller\_admin\_email) | The administrator email address to be added to the admin user in the Aviatrix Controller | `string` | n/a | yes |
| <a name="input_aviatrix_controller_customer_id"></a> [aviatrix\_controller\_customer\_id](#input\_aviatrix\_controller\_customer\_id) | The license/customer id for the Aviatrix Controller. | `string` | n/a | yes |
| <a name="input_aviatrix_controller_password"></a> [aviatrix\_controller\_password](#input\_aviatrix\_controller\_password) | The password to be added to the admin account of the Aviatrix Controller | `string` | n/a | yes |
| <a name="input_aviatrix_controller_private_ip"></a> [aviatrix\_controller\_private\_ip](#input\_aviatrix\_controller\_private\_ip) | The Private IP Address of the Aviatrix Controller. | `string` | n/a | yes |
| <a name="input_aviatrix_controller_public_ip"></a> [aviatrix\_controller\_public\_ip](#input\_aviatrix\_controller\_public\_ip) | The Public IP Address of the Aviatrix Controller. | `string` | n/a | yes |
| <a name="input_aviatrix_controller_version"></a> [aviatrix\_controller\_version](#input\_aviatrix\_controller\_version) | The version of the Aviatrix Controller. | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->