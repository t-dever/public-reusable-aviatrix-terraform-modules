# initial_setup

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 2.80.0 |
| <a name="requirement_local"></a> [local](#requirement\_local) | 2.1.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 2.80.0 |
| <a name="provider_time"></a> [time](#provider\_time) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_key_vault.key_vault](https://registry.terraform.io/providers/hashicorp/azurerm/2.80.0/docs/resources/key_vault) | resource |
| [azurerm_log_analytics_workspace.log_analytics](https://registry.terraform.io/providers/hashicorp/azurerm/2.80.0/docs/resources/log_analytics_workspace) | resource |
| [azurerm_role_assignment.key_vault_pipeline_service_principal](https://registry.terraform.io/providers/hashicorp/azurerm/2.80.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.key_vault_user](https://registry.terraform.io/providers/hashicorp/azurerm/2.80.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.storage_account_pipeline_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/2.80.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.storage_account_user_blob_owner](https://registry.terraform.io/providers/hashicorp/azurerm/2.80.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.storage_account_user_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/2.80.0/docs/resources/role_assignment) | resource |
| [azurerm_storage_account_network_rules.storage_account_access_rules](https://registry.terraform.io/providers/hashicorp/azurerm/2.80.0/docs/resources/storage_account_network_rules) | resource |
| [azurerm_storage_container.controller_backup_container](https://registry.terraform.io/providers/hashicorp/azurerm/2.80.0/docs/resources/storage_container) | resource |
| [time_sleep.wait_1_minute](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/2.80.0/docs/data-sources/client_config) | data source |
| [azurerm_resource_group.resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/2.80.0/docs/data-sources/resource_group) | data source |
| [azurerm_storage_account.storage_account](https://registry.terraform.io/providers/hashicorp/azurerm/2.80.0/docs/data-sources/storage_account) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_build_agent_ip_address"></a> [build\_agent\_ip\_address](#input\_build\_agent\_ip\_address) | The Public IP Address of the build agent to add to the NSG allow rule | `string` | `"1.1.1.1"` | no |
| <a name="input_controller_user_public_ip_address"></a> [controller\_user\_public\_ip\_address](#input\_controller\_user\_public\_ip\_address) | The public IP address of the user that is logging into the controller | `string` | n/a | yes |
| <a name="input_resource_prefix"></a> [resource\_prefix](#input\_resource\_prefix) | The prefix to the resource group that will be used for all created resources | `string` | n/a | yes |
| <a name="input_user_principal_id"></a> [user\_principal\_id](#input\_user\_principal\_id) | The ID of the user that needs to access the key vault via Azure Portal GUI. This is used to give key vault secrets officer role | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_key_vault_id"></a> [key\_vault\_id](#output\_key\_vault\_id) | The key vault ID |
| <a name="output_key_vault_name"></a> [key\_vault\_name](#output\_key\_vault\_name) | The key vault name |
| <a name="output_log_analytics_id"></a> [log\_analytics\_id](#output\_log\_analytics\_id) | The log analytics id |
| <a name="output_log_analytics_name"></a> [log\_analytics\_name](#output\_log\_analytics\_name) | The log analytics name |
| <a name="output_log_analytics_region"></a> [log\_analytics\_region](#output\_log\_analytics\_region) | The log analytics regions/location |
| <a name="output_log_analytics_workspace_id"></a> [log\_analytics\_workspace\_id](#output\_log\_analytics\_workspace\_id) | The log analytics workspace id |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | The resource group name |
| <a name="output_storage_account_id"></a> [storage\_account\_id](#output\_storage\_account\_id) | The storage account ID |
| <a name="output_storage_account_name"></a> [storage\_account\_name](#output\_storage\_account\_name) | The storage account name |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 2.80.0 |
| <a name="requirement_local"></a> [local](#requirement\_local) | 2.1.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 2.80.0 |
| <a name="provider_time"></a> [time](#provider\_time) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_key_vault.key_vault](https://registry.terraform.io/providers/hashicorp/azurerm/2.80.0/docs/resources/key_vault) | resource |
| [azurerm_log_analytics_workspace.log_analytics](https://registry.terraform.io/providers/hashicorp/azurerm/2.80.0/docs/resources/log_analytics_workspace) | resource |
| [azurerm_role_assignment.key_vault_pipeline_service_principal](https://registry.terraform.io/providers/hashicorp/azurerm/2.80.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.key_vault_user](https://registry.terraform.io/providers/hashicorp/azurerm/2.80.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.storage_account_pipeline_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/2.80.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.storage_account_user_blob_owner](https://registry.terraform.io/providers/hashicorp/azurerm/2.80.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.storage_account_user_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/2.80.0/docs/resources/role_assignment) | resource |
| [azurerm_storage_container.controller_backup_container](https://registry.terraform.io/providers/hashicorp/azurerm/2.80.0/docs/resources/storage_container) | resource |
| [time_sleep.wait_1_minute](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/2.80.0/docs/data-sources/client_config) | data source |
| [azurerm_resource_group.resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/2.80.0/docs/data-sources/resource_group) | data source |
| [azurerm_storage_account.storage_account](https://registry.terraform.io/providers/hashicorp/azurerm/2.80.0/docs/data-sources/storage_account) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_build_agent_ip_address"></a> [build\_agent\_ip\_address](#input\_build\_agent\_ip\_address) | The Public IP Address of the build agent to add to the NSG allow rule | `string` | `"1.1.1.1"` | no |
| <a name="input_controller_user_public_ip_address"></a> [controller\_user\_public\_ip\_address](#input\_controller\_user\_public\_ip\_address) | The public IP address of the user that is logging into the controller | `string` | n/a | yes |
| <a name="input_resource_prefix"></a> [resource\_prefix](#input\_resource\_prefix) | The prefix to the resource group that will be used for all created resources | `string` | n/a | yes |
| <a name="input_user_principal_id"></a> [user\_principal\_id](#input\_user\_principal\_id) | The ID of the user that needs to access the key vault via Azure Portal GUI. This is used to give key vault secrets officer role | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_key_vault_id"></a> [key\_vault\_id](#output\_key\_vault\_id) | The key vault ID |
| <a name="output_key_vault_name"></a> [key\_vault\_name](#output\_key\_vault\_name) | The key vault name |
| <a name="output_log_analytics_id"></a> [log\_analytics\_id](#output\_log\_analytics\_id) | The log analytics id |
| <a name="output_log_analytics_name"></a> [log\_analytics\_name](#output\_log\_analytics\_name) | The log analytics name |
| <a name="output_log_analytics_region"></a> [log\_analytics\_region](#output\_log\_analytics\_region) | The log analytics regions/location |
| <a name="output_log_analytics_workspace_id"></a> [log\_analytics\_workspace\_id](#output\_log\_analytics\_workspace\_id) | The log analytics workspace id |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | The resource group name |
| <a name="output_storage_account_backup_container_name"></a> [storage\_account\_backup\_container\_name](#output\_storage\_account\_backup\_container\_name) | The name of the container where backups will be stored. |
| <a name="output_storage_account_id"></a> [storage\_account\_id](#output\_storage\_account\_id) | The storage account ID |
| <a name="output_storage_account_name"></a> [storage\_account\_name](#output\_storage\_account\_name) | The storage account name |
<!-- END_TF_DOCS -->