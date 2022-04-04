<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aviatrix"></a> [aviatrix](#requirement\_aviatrix) | 2.21.0-6.6.ga |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >=2.92.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aviatrix"></a> [aviatrix](#provider\_aviatrix) | 2.21.0-6.6.ga |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aviatrix_controller_config.controller_backup](https://registry.terraform.io/providers/AviatrixSystems/aviatrix/2.21.0-6.6.ga/docs/resources/controller_config) | resource |
| [aviatrix_controller_security_group_management_config.security_group_management](https://registry.terraform.io/providers/AviatrixSystems/aviatrix/2.21.0-6.6.ga/docs/resources/controller_security_group_management_config) | resource |
| [aviatrix_copilot_association.copilot_association](https://registry.terraform.io/providers/AviatrixSystems/aviatrix/2.21.0-6.6.ga/docs/resources/copilot_association) | resource |
| [aviatrix_netflow_agent.netflow_agent](https://registry.terraform.io/providers/AviatrixSystems/aviatrix/2.21.0-6.6.ga/docs/resources/netflow_agent) | resource |
| [aviatrix_remote_syslog.remote_syslog](https://registry.terraform.io/providers/AviatrixSystems/aviatrix/2.21.0-6.6.ga/docs/resources/remote_syslog) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aviatrix_access_account_name"></a> [aviatrix\_access\_account\_name](#input\_aviatrix\_access\_account\_name) | The account name used to enable all the configuration settings. | `string` | n/a | yes |
| <a name="input_controller_password"></a> [controller\_password](#input\_controller\_password) | The controllers password. | `string` | n/a | yes |
| <a name="input_controller_public_ip"></a> [controller\_public\_ip](#input\_controller\_public\_ip) | The controllers public IP address. | `string` | `"1.2.3.4"` | no |
| <a name="input_controller_username"></a> [controller\_username](#input\_controller\_username) | The controllers username. | `string` | `"admin"` | no |
| <a name="input_copilot_ip_address"></a> [copilot\_ip\_address](#input\_copilot\_ip\_address) | The CoPilot IP Address to be associated to the controller. | `string` | `""` | no |
| <a name="input_enable_azure_backup"></a> [enable\_azure\_backup](#input\_enable\_azure\_backup) | Enables Backups to azure storage account. | <pre>object({<br>    backup_account_name   = string,<br>    backup_storage_name   = string,<br>    backup_container_name = string,<br>    backup_region         = string<br>  })</pre> | <pre>{<br>  "backup_account_name": "",<br>  "backup_container_name": "",<br>  "backup_region": "",<br>  "backup_storage_name": ""<br>}</pre> | no |
| <a name="input_enable_netflow_to_copilot"></a> [enable\_netflow\_to\_copilot](#input\_enable\_netflow\_to\_copilot) | Enables netflow logging to CoPilot. | `bool` | `false` | no |
| <a name="input_enable_rsyslog_to_copilot"></a> [enable\_rsyslog\_to\_copilot](#input\_enable\_rsyslog\_to\_copilot) | Enables rsyslog logging to CoPilot. | `bool` | `false` | no |
| <a name="input_enable_security_group_management"></a> [enable\_security\_group\_management](#input\_enable\_security\_group\_management) | Enables security group management. | `bool` | `true` | no |
| <a name="input_netflow_port"></a> [netflow\_port](#input\_netflow\_port) | The port used for netflow data. | `string` | `"31283"` | no |
| <a name="input_rsyslog_port"></a> [rsyslog\_port](#input\_rsyslog\_port) | The port used for rsyslog data. | `string` | `"5000"` | no |
| <a name="input_rsyslog_protocol"></a> [rsyslog\_protocol](#input\_rsyslog\_protocol) | The protocol used for rsyslog. | `string` | `"UDP"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->