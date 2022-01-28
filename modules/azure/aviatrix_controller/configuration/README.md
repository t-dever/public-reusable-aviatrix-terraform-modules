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
| [aviatrix_controller_config.controller_backup](https://registry.terraform.io/providers/AviatrixSystems/aviatrix/latest/docs/resources/controller_config) | resource |
| [aviatrix_controller_security_group_management_config.security_group_management](https://registry.terraform.io/providers/AviatrixSystems/aviatrix/latest/docs/resources/controller_security_group_management_config) | resource |
| [aviatrix_copilot_association.copilot_association](https://registry.terraform.io/providers/AviatrixSystems/aviatrix/latest/docs/resources/copilot_association) | resource |
| [aviatrix_netflow_agent.netflow_agent](https://registry.terraform.io/providers/AviatrixSystems/aviatrix/latest/docs/resources/netflow_agent) | resource |
| [aviatrix_remote_syslog.remote_syslog](https://registry.terraform.io/providers/AviatrixSystems/aviatrix/latest/docs/resources/remote_syslog) | resource |
| [azurerm_network_security_rule.allow_controller_inbound_to_copilot](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.allow_copilot_inbound_to_controller](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.allow_netflow_inbound_to_copilot](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.allow_user_to_controller_nsg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_subnet_network_security_group_association.azure_controller_nsg_association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_network_security_group.controller_security_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/network_security_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_azure_account_name"></a> [azure\_account\_name](#input\_azure\_account\_name) | The account name to add to the controller | `string` | n/a | yes |
| <a name="input_backup_container_name"></a> [backup\_container\_name](#input\_backup\_container\_name) | The name of the storage account container to store backups for the aviatrix controller. | `string` | `""` | no |
| <a name="input_backup_region"></a> [backup\_region](#input\_backup\_region) | The region where the storage account is stored. | `string` | `""` | no |
| <a name="input_backup_storage_name"></a> [backup\_storage\_name](#input\_backup\_storage\_name) | The name of the storage account to store backups for the aviatrix controller. | `string` | `""` | no |
| <a name="input_client_secret"></a> [client\_secret](#input\_client\_secret) | The Client secret for the account to be added | `string` | n/a | yes |
| <a name="input_controller_password"></a> [controller\_password](#input\_controller\_password) | The controllers password. | `string` | n/a | yes |
| <a name="input_controller_private_ip"></a> [controller\_private\_ip](#input\_controller\_private\_ip) | The controllers private IP address. | `string` | `"1.2.3.4"` | no |
| <a name="input_controller_public_ip"></a> [controller\_public\_ip](#input\_controller\_public\_ip) | The controllers public IP address. | `string` | `"1.2.3.4"` | no |
| <a name="input_controller_subnet_id"></a> [controller\_subnet\_id](#input\_controller\_subnet\_id) | The controller subnet id. | `string` | n/a | yes |
| <a name="input_controller_user_public_ip_address"></a> [controller\_user\_public\_ip\_address](#input\_controller\_user\_public\_ip\_address) | The public IP address of the user that is logging into the controller | `string` | n/a | yes |
| <a name="input_controller_username"></a> [controller\_username](#input\_controller\_username) | The controllers username. | `string` | `"admin"` | no |
| <a name="input_copilot_private_ip"></a> [copilot\_private\_ip](#input\_copilot\_private\_ip) | The CoPilots Private IP Address | `string` | `""` | no |
| <a name="input_copilot_public_ip"></a> [copilot\_public\_ip](#input\_copilot\_public\_ip) | The CoPilots Public IP Address. | `string` | `""` | no |
| <a name="input_enable_backup"></a> [enable\_backup](#input\_enable\_backup) | Enable backup for the aviatrix controller. | `bool` | `false` | no |
| <a name="input_enable_netflow_to_copilot"></a> [enable\_netflow\_to\_copilot](#input\_enable\_netflow\_to\_copilot) | Enables netflow logging to CoPilot. | `bool` | `false` | no |
| <a name="input_enable_rsyslog_to_copilot"></a> [enable\_rsyslog\_to\_copilot](#input\_enable\_rsyslog\_to\_copilot) | Enables rsyslog logging to CoPilot. | `bool` | `false` | no |
| <a name="input_enable_security_group_management"></a> [enable\_security\_group\_management](#input\_enable\_security\_group\_management) | Enables security group management. | `bool` | `true` | no |
| <a name="input_netflow_port"></a> [netflow\_port](#input\_netflow\_port) | The port used for netflow data. | `string` | `"31283"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the controller resource group | `string` | n/a | yes |
| <a name="input_rsyslog_port"></a> [rsyslog\_port](#input\_rsyslog\_port) | The port used for rsyslog data. | `string` | `"5000"` | no |
| <a name="input_rsyslog_protocol"></a> [rsyslog\_protocol](#input\_rsyslog\_protocol) | The protocol used for rsyslog. | `string` | `"UDP"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aviatrix_azure_account"></a> [aviatrix\_azure\_account](#output\_aviatrix\_azure\_account) | The name of the account added. |
| <a name="output_user_public_ip_address"></a> [user\_public\_ip\_address](#output\_user\_public\_ip\_address) | The ip address of the user accessing the stuff. |
<!-- END_TF_DOCS -->