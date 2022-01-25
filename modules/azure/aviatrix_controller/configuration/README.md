<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aviatrix"></a> [aviatrix](#requirement\_aviatrix) | >=2.20.3 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >=2.92.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aviatrix"></a> [aviatrix](#provider\_aviatrix) | >=2.20.3 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >=2.92.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aviatrix_account.azure_account](https://registry.terraform.io/providers/AviatrixSystems/aviatrix/latest/docs/resources/account) | resource |
| [aviatrix_controller_security_group_management_config.security_group_management](https://registry.terraform.io/providers/AviatrixSystems/aviatrix/latest/docs/resources/controller_security_group_management_config) | resource |
| [azurerm_network_security_rule.allow_user_to_controller_nsg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_subnet_network_security_group_association.azure_controller_nsg_association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_network_security_group.controller_security_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/network_security_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_azure_account_name"></a> [azure\_account\_name](#input\_azure\_account\_name) | The account name to add to the controller | `string` | n/a | yes |
| <a name="input_client_secret"></a> [client\_secret](#input\_client\_secret) | The Client secret for the account to be added | `string` | n/a | yes |
| <a name="input_controller_ip"></a> [controller\_ip](#input\_controller\_ip) | The controllers public IP address. | `string` | `"1.2.3.4"` | no |
| <a name="input_controller_password"></a> [controller\_password](#input\_controller\_password) | The controllers password. | `string` | `""` | no |
| <a name="input_controller_subnet_id"></a> [controller\_subnet\_id](#input\_controller\_subnet\_id) | The controller subnet id. | `string` | n/a | yes |
| <a name="input_controller_user_public_ip_address"></a> [controller\_user\_public\_ip\_address](#input\_controller\_user\_public\_ip\_address) | The public IP address of the user that is logging into the controller | `string` | n/a | yes |
| <a name="input_controller_username"></a> [controller\_username](#input\_controller\_username) | The controllers username. | `string` | `"admin"` | no |
| <a name="input_resource_group_location"></a> [resource\_group\_location](#input\_resource\_group\_location) | The name of the controller resource group location | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the controller resource group | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aviatrix_azure_account"></a> [aviatrix\_azure\_account](#output\_aviatrix\_azure\_account) | n/a |
<!-- END_TF_DOCS -->