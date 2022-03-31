# aviatrix_controller

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |
| <a name="provider_local"></a> [local](#provider\_local) | n/a |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_dev_test_global_vm_shutdown_schedule.controller_shutdown](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dev_test_global_vm_shutdown_schedule) | resource |
| [azurerm_dev_test_global_vm_shutdown_schedule.copilot_shutdown](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dev_test_global_vm_shutdown_schedule) | resource |
| [azurerm_key_vault_secret.aviatrix_admin_secret](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_linux_virtual_machine.aviatrix_controller_vm](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine) | resource |
| [azurerm_linux_virtual_machine.aviatrix_copilot_vm](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine) | resource |
| [azurerm_network_interface.azure_controller_nic](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_network_interface.azure_copilot_nic](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_network_security_group.controller_security_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_network_security_rule.allow_build_agent_to_controller_nsg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.allow_user_to_controller_nsg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_network_watcher_flow_log.nsg_flow_logs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_watcher_flow_log) | resource |
| [azurerm_public_ip.azure_controller_public_ip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_public_ip.azure_copilot_public_ip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_resource_group.resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_storage_account.storage_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |
| [azurerm_subnet.azure_controller_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet_network_security_group_association.azure_controller_nsg_association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_virtual_network.azure_controller_vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |
| [local_file.controller_customer_id](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.controller_secret](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [null_resource.initial_config](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [random_password.generate_controller_secret](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_email"></a> [admin\_email](#input\_admin\_email) | The email address used for the aviatrix controller registration. | `string` | n/a | yes |
| <a name="input_aviatrix_azure_access_account_name"></a> [aviatrix\_azure\_access\_account\_name](#input\_aviatrix\_azure\_access\_account\_name) | The account used to manage the aviatrix controller in azure | `string` | n/a | yes |
| <a name="input_azure_application_key"></a> [azure\_application\_key](#input\_azure\_application\_key) | The application/client secret/key to perform a backup restore | `string` | n/a | yes |
| <a name="input_build_agent_ip_address"></a> [build\_agent\_ip\_address](#input\_build\_agent\_ip\_address) | The Public IP Address of the build agent to add to the NSG allow rule | `string` | `"1.1.1.1"` | no |
| <a name="input_controller_customer_id"></a> [controller\_customer\_id](#input\_controller\_customer\_id) | The customer id for the aviatrix controller | `string` | n/a | yes |
| <a name="input_controller_subnet_address_prefix"></a> [controller\_subnet\_address\_prefix](#input\_controller\_subnet\_address\_prefix) | The subnet address prefix that's used for the controller and copilot VMs. e.g. 10.0.0.0/24 | `string` | n/a | yes |
| <a name="input_controller_user_public_ip_address"></a> [controller\_user\_public\_ip\_address](#input\_controller\_user\_public\_ip\_address) | The public IP address of the user that is logging into the controller | `string` | n/a | yes |
| <a name="input_controller_version"></a> [controller\_version](#input\_controller\_version) | The version used for the controller | `string` | `"UserConnect-6.5.2613"` | no |
| <a name="input_controller_vm_size"></a> [controller\_vm\_size](#input\_controller\_vm\_size) | The size for the controller VM. | `string` | `"Standard_A4_v2"` | no |
| <a name="input_copilot_vm_size"></a> [copilot\_vm\_size](#input\_copilot\_vm\_size) | The size for the Co-Pilot VM. | `string` | `"Standard_D8as_v4"` | no |
| <a name="input_key_vault_id"></a> [key\_vault\_id](#input\_key\_vault\_id) | The key vault ID where to store the admin credentials | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Location of the resource group | `string` | n/a | yes |
| <a name="input_log_analytics_id"></a> [log\_analytics\_id](#input\_log\_analytics\_id) | The log analytics id. | `string` | n/a | yes |
| <a name="input_log_analytics_location"></a> [log\_analytics\_location](#input\_log\_analytics\_location) | The log analytics location. | `string` | n/a | yes |
| <a name="input_log_analytics_workspace_id"></a> [log\_analytics\_workspace\_id](#input\_log\_analytics\_workspace\_id) | The log analytics workspace id. | `string` | n/a | yes |
| <a name="input_network_watcher_name"></a> [network\_watcher\_name](#input\_network\_watcher\_name) | The name of the network watcher instance for nsg flow logs. | `string` | n/a | yes |
| <a name="input_resource_prefix"></a> [resource\_prefix](#input\_resource\_prefix) | The prefix to the resource group that will be used for all created resources | `string` | n/a | yes |
| <a name="input_vnet_address_prefix"></a> [vnet\_address\_prefix](#input\_vnet\_address\_prefix) | The address prefix used for the vnet e.g. 10.0.0.0/22 | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aviatrix_azure_account"></a> [aviatrix\_azure\_account](#output\_aviatrix\_azure\_account) | The Azure account provisioned in the aviatrix controller used for accessing subscriptions |
| <a name="output_controller_admin_password"></a> [controller\_admin\_password](#output\_controller\_admin\_password) | The controller admin password |
| <a name="output_controller_public_ip"></a> [controller\_public\_ip](#output\_controller\_public\_ip) | The IP Address of the Aviatrix Controller |
| <a name="output_controller_resource_group_name"></a> [controller\_resource\_group\_name](#output\_controller\_resource\_group\_name) | The resource group name of the controller |
| <a name="output_controller_security_group_name"></a> [controller\_security\_group\_name](#output\_controller\_security\_group\_name) | The Controllers network security group |
| <a name="output_controller_subnet_id"></a> [controller\_subnet\_id](#output\_controller\_subnet\_id) | The subnet id for controller |
| <a name="output_user_public_ip_address"></a> [user\_public\_ip\_address](#output\_user\_public\_ip\_address) | The public IP address of the User; used for NSG rules |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >=2.92.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | 3.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >=2.92.0 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aviatrix_controller_initialize"></a> [aviatrix\_controller\_initialize](#module\_aviatrix\_controller\_initialize) | git::https://github.com/t-dever/public-reusable-aviatrix-terraform-modules//modules/aviatrix/controller_initialize | hotfix/updateAzureControllerDeployment |

## Resources

| Name | Type |
|------|------|
| [azurerm_dev_test_global_vm_shutdown_schedule.controller_shutdown](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dev_test_global_vm_shutdown_schedule) | resource |
| [azurerm_dev_test_global_vm_shutdown_schedule.copilot_shutdown](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dev_test_global_vm_shutdown_schedule) | resource |
| [azurerm_key_vault_secret.aviatrix_controller_admin_secret](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.aviatrix_controller_public_ip_secret](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.aviatrix_controller_virtual_machine_secret](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.aviatrix_copilot_virtual_machine_secret](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_linux_virtual_machine.aviatrix_controller_vm](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine) | resource |
| [azurerm_linux_virtual_machine.aviatrix_copilot_vm](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine) | resource |
| [azurerm_network_interface.azure_controller_nic](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_network_interface.azure_copilot_nic](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_network_security_group.aviatrix_controller_security_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_network_security_rule.allow_controller_inbound_to_copilot](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.allow_copilot_inbound_to_controller](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.allow_inbound_public_ips_to_controller_nsg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_public_ip.azure_controller_public_ip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_public_ip.azure_copilot_public_ip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_resource_group.resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_subnet.azure_controller_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet_network_security_group_association.azure_controller_nsg_association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_virtual_network.azure_controller_vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |
| [random_password.generate_aviatrix_controller_admin_secret](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.generate_aviatrix_controller_virtual_machine_admin_secret](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.generate_aviatrix_copilot_virtual_machine_admin_secret](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_ips"></a> [allowed\_ips](#input\_allowed\_ips) | List of allowed ips to be added as ingress rule for security group. | `list(string)` | `[]` | no |
| <a name="input_aviatrix_azure_primary_account_client_secret"></a> [aviatrix\_azure\_primary\_account\_client\_secret](#input\_aviatrix\_azure\_primary\_account\_client\_secret) | The Azure Primary Account Client Secret to be added to the Aviatrix Controller Access Accounts. | `string` | `""` | no |
| <a name="input_aviatrix_azure_primary_account_name"></a> [aviatrix\_azure\_primary\_account\_name](#input\_aviatrix\_azure\_primary\_account\_name) | The Azure Primary Account name to be added to the Aviatrix Controller Access Accounts. | `string` | `""` | no |
| <a name="input_aviatrix_controller_admin_email"></a> [aviatrix\_controller\_admin\_email](#input\_aviatrix\_controller\_admin\_email) | The email address used for the aviatrix controller registration. | `string` | n/a | yes |
| <a name="input_aviatrix_controller_customer_id"></a> [aviatrix\_controller\_customer\_id](#input\_aviatrix\_controller\_customer\_id) | The customer id for the aviatrix controller | `string` | n/a | yes |
| <a name="input_aviatrix_controller_instance_size"></a> [aviatrix\_controller\_instance\_size](#input\_aviatrix\_controller\_instance\_size) | Aviatrix Controller instance size. | `string` | `"Standard_D2as_v4"` | no |
| <a name="input_aviatrix_controller_name"></a> [aviatrix\_controller\_name](#input\_aviatrix\_controller\_name) | The name of the azure virtual machine resource. | `string` | `"aviatrix-controller-vm"` | no |
| <a name="input_aviatrix_controller_password"></a> [aviatrix\_controller\_password](#input\_aviatrix\_controller\_password) | The password to be applied to the aviatrix controller admin account. | `string` | `""` | no |
| <a name="input_aviatrix_controller_public_ssh_key"></a> [aviatrix\_controller\_public\_ssh\_key](#input\_aviatrix\_controller\_public\_ssh\_key) | Use a public SSH key for authentication to Aviatrix Controller | `string` | `""` | no |
| <a name="input_aviatrix_controller_security_group_name"></a> [aviatrix\_controller\_security\_group\_name](#input\_aviatrix\_controller\_security\_group\_name) | The name of the security group for the Aviatrix Controller. | `string` | `"aviatrix-controller-security-group"` | no |
| <a name="input_aviatrix_controller_username"></a> [aviatrix\_controller\_username](#input\_aviatrix\_controller\_username) | The username to be applied to the aviatrix controller for admin access. | `string` | `"admin"` | no |
| <a name="input_aviatrix_controller_version"></a> [aviatrix\_controller\_version](#input\_aviatrix\_controller\_version) | The version used for the controller | `string` | `"6.6"` | no |
| <a name="input_aviatrix_controller_virtual_machine_admin_password"></a> [aviatrix\_controller\_virtual\_machine\_admin\_password](#input\_aviatrix\_controller\_virtual\_machine\_admin\_password) | Admin Password for the controller virtual machine. | `string` | `""` | no |
| <a name="input_aviatrix_controller_virtual_machine_admin_username"></a> [aviatrix\_controller\_virtual\_machine\_admin\_username](#input\_aviatrix\_controller\_virtual\_machine\_admin\_username) | Admin Username for the controller virtual machine. | `string` | `"aviatrix"` | no |
| <a name="input_aviatrix_copilot_instance_size"></a> [aviatrix\_copilot\_instance\_size](#input\_aviatrix\_copilot\_instance\_size) | The size for the CoPilot VM. | `string` | `"Standard_D8as_v4"` | no |
| <a name="input_aviatrix_copilot_name"></a> [aviatrix\_copilot\_name](#input\_aviatrix\_copilot\_name) | The name of the CoPilot VM. | `string` | `"aviatrix-copilot-vm"` | no |
| <a name="input_aviatrix_copilot_public_ssh_key"></a> [aviatrix\_copilot\_public\_ssh\_key](#input\_aviatrix\_copilot\_public\_ssh\_key) | Use a public SSH key for local. authentication to Aviatrix Copilot. | `string` | `""` | no |
| <a name="input_aviatrix_copilot_virtual_machine_admin_password"></a> [aviatrix\_copilot\_virtual\_machine\_admin\_password](#input\_aviatrix\_copilot\_virtual\_machine\_admin\_password) | Admin Password for the copilot virtual machine. | `string` | `""` | no |
| <a name="input_aviatrix_copilot_virtual_machine_admin_username"></a> [aviatrix\_copilot\_virtual\_machine\_admin\_username](#input\_aviatrix\_copilot\_virtual\_machine\_admin\_username) | Admin Username for the copilot virtual machine. | `string` | `"aviatrix"` | no |
| <a name="input_aviatrix_deploy_copilot"></a> [aviatrix\_deploy\_copilot](#input\_aviatrix\_deploy\_copilot) | Deploy Aviatrix CoPilot? | `bool` | `false` | no |
| <a name="input_aviatrix_enable_security_group_management"></a> [aviatrix\_enable\_security\_group\_management](#input\_aviatrix\_enable\_security\_group\_management) | Enables Auto Security Group Management within the Aviatrix Controller. A primary access account is required for implementation. | `bool` | `true` | no |
| <a name="input_controller_subnet_address_prefix"></a> [controller\_subnet\_address\_prefix](#input\_controller\_subnet\_address\_prefix) | The subnet address prefix that's used for the controller and copilot VMs. e.g. 10.0.0.0/24 | `string` | `"10.0.0.0/24"` | no |
| <a name="input_enable_scheduled_shutdown"></a> [enable\_scheduled\_shutdown](#input\_enable\_scheduled\_shutdown) | Enable automatic shutdown on controller and copilot gateway. | `bool` | `true` | no |
| <a name="input_enable_spot_instances"></a> [enable\_spot\_instances](#input\_enable\_spot\_instances) | Make the controller and copilot spot instances for best effort or development workloads. | `bool` | `true` | no |
| <a name="input_key_vault_id"></a> [key\_vault\_id](#input\_key\_vault\_id) | The key vault ID where to store the admin credentials | `string` | `""` | no |
| <a name="input_location"></a> [location](#input\_location) | Location of the resource group | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The resource group name to be created. | `string` | n/a | yes |
| <a name="input_store_credentials_in_key_vault"></a> [store\_credentials\_in\_key\_vault](#input\_store\_credentials\_in\_key\_vault) | Elect to store the generated admin credentials in the key vault | `bool` | `false` | no |
| <a name="input_vnet_address_prefix"></a> [vnet\_address\_prefix](#input\_vnet\_address\_prefix) | The address prefix used for the vnet e.g. 10.0.0.0/22 | `string` | `"10.0.0.0/23"` | no |
| <a name="input_vnet_name"></a> [vnet\_name](#input\_vnet\_name) | The name for the Virtual Network | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_controller_admin_password"></a> [controller\_admin\_password](#output\_controller\_admin\_password) | The controller admin password |
| <a name="output_controller_admin_username"></a> [controller\_admin\_username](#output\_controller\_admin\_username) | The controller admin username. |
| <a name="output_controller_private_ip"></a> [controller\_private\_ip](#output\_controller\_private\_ip) | The Private IP Address of the Aviatrix Controller |
| <a name="output_controller_public_ip"></a> [controller\_public\_ip](#output\_controller\_public\_ip) | The Public IP Address of the Aviatrix Controller |
| <a name="output_controller_resource_group_name"></a> [controller\_resource\_group\_name](#output\_controller\_resource\_group\_name) | The resource group name of the controller |
| <a name="output_controller_subnet_id"></a> [controller\_subnet\_id](#output\_controller\_subnet\_id) | The subnet id for controller |
| <a name="output_copilot_private_ip"></a> [copilot\_private\_ip](#output\_copilot\_private\_ip) | The Private IP Address of the Aviatrix CoPilot Instance |
| <a name="output_copilot_public_ip"></a> [copilot\_public\_ip](#output\_copilot\_public\_ip) | The Public IP Address of the Aviatrix CoPilot Instance. |
| <a name="output_resource_group_location"></a> [resource\_group\_location](#output\_resource\_group\_location) | The resource group location |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | The resource group name |
<!-- END_TF_DOCS -->