# spokes

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aviatrix"></a> [aviatrix](#requirement\_aviatrix) | 2.20.1 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 2.80.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aviatrix"></a> [aviatrix](#provider\_aviatrix) | 2.20.1 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 2.80.0 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aviatrix_spoke_gateway.azure_spoke_gateway](https://registry.terraform.io/providers/AviatrixSystems/aviatrix/2.20.1/docs/resources/spoke_gateway) | resource |
| [aviatrix_spoke_transit_attachment.attach_spoke](https://registry.terraform.io/providers/AviatrixSystems/aviatrix/2.20.1/docs/resources/spoke_transit_attachment) | resource |
| [azurerm_dev_test_global_vm_shutdown_schedule.gateway_shutdown](https://registry.terraform.io/providers/hashicorp/azurerm/2.80.0/docs/resources/dev_test_global_vm_shutdown_schedule) | resource |
| [azurerm_dev_test_global_vm_shutdown_schedule.vm_shutdown](https://registry.terraform.io/providers/hashicorp/azurerm/2.80.0/docs/resources/dev_test_global_vm_shutdown_schedule) | resource |
| [azurerm_key_vault_secret.vm1_secret](https://registry.terraform.io/providers/hashicorp/azurerm/2.80.0/docs/resources/key_vault_secret) | resource |
| [azurerm_linux_virtual_machine.virtual_machine1](https://registry.terraform.io/providers/hashicorp/azurerm/2.80.0/docs/resources/linux_virtual_machine) | resource |
| [azurerm_network_interface.virtual_machine1_nic1](https://registry.terraform.io/providers/hashicorp/azurerm/2.80.0/docs/resources/network_interface) | resource |
| [azurerm_public_ip.azure_gateway_public_ip](https://registry.terraform.io/providers/hashicorp/azurerm/2.80.0/docs/resources/public_ip) | resource |
| [azurerm_resource_group.azure_spoke_resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/2.80.0/docs/resources/resource_group) | resource |
| [azurerm_storage_account.spoke_storage_account](https://registry.terraform.io/providers/hashicorp/azurerm/2.80.0/docs/resources/storage_account) | resource |
| [azurerm_subnet.azure_spoke_gateway_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/2.80.0/docs/resources/subnet) | resource |
| [azurerm_subnet.azure_virtual_machines_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/2.80.0/docs/resources/subnet) | resource |
| [azurerm_virtual_network.azure_spoke_vnet](https://registry.terraform.io/providers/hashicorp/azurerm/2.80.0/docs/resources/virtual_network) | resource |
| [random_password.generate_vm1_secret](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [azurerm_virtual_machine.gateway_vm_data](https://registry.terraform.io/providers/hashicorp/azurerm/2.80.0/docs/data-sources/virtual_machine) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aviatrix_azure_account"></a> [aviatrix\_azure\_account](#input\_aviatrix\_azure\_account) | The name of the account configured in the Aviatrix Controller. | `string` | n/a | yes |
| <a name="input_controller_password"></a> [controller\_password](#input\_controller\_password) | The Aviatrix Controller admin credentials. | `string` | n/a | yes |
| <a name="input_controller_public_ip"></a> [controller\_public\_ip](#input\_controller\_public\_ip) | The Aviatrix Controller public IP Address. | `string` | n/a | yes |
| <a name="input_controller_username"></a> [controller\_username](#input\_controller\_username) | The name for the Aviatrix Controller login. | `string` | `"admin"` | no |
| <a name="input_gateway_subnet_address_prefix"></a> [gateway\_subnet\_address\_prefix](#input\_gateway\_subnet\_address\_prefix) | The address prefix for gateway subnet in vnet. | `string` | n/a | yes |
| <a name="input_key_vault_id"></a> [key\_vault\_id](#input\_key\_vault\_id) | The key vault id where the virtual machine secret will be stored. | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The location used for deployment of resources. | `string` | n/a | yes |
| <a name="input_resource_prefix"></a> [resource\_prefix](#input\_resource\_prefix) | The resource prefix to use as the prefix for all resource names. | `string` | n/a | yes |
| <a name="input_transit_gateway_name"></a> [transit\_gateway\_name](#input\_transit\_gateway\_name) | The transit gateway name the spoke will be peered with. | `string` | n/a | yes |
| <a name="input_virtual_machines_subnet_address_prefix"></a> [virtual\_machines\_subnet\_address\_prefix](#input\_virtual\_machines\_subnet\_address\_prefix) | The address prefix for virtual machines subnet in vnet. | `string` | n/a | yes |
| <a name="input_vnet_address_prefix"></a> [vnet\_address\_prefix](#input\_vnet\_address\_prefix) | The address prefix used for the virtual network. | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aviatrix"></a> [aviatrix](#requirement\_aviatrix) | >=2.20.3 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 2.89.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aviatrix"></a> [aviatrix](#provider\_aviatrix) | >=2.20.3 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 2.89.0 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aviatrix_segmentation_security_domain.spoke_segmentation_security_domain](https://registry.terraform.io/providers/AviatrixSystems/aviatrix/latest/docs/resources/segmentation_security_domain) | resource |
| [aviatrix_segmentation_security_domain_association.segmentation_security_domain_association](https://registry.terraform.io/providers/AviatrixSystems/aviatrix/latest/docs/resources/segmentation_security_domain_association) | resource |
| [aviatrix_segmentation_security_domain_connection_policy.segmentation_security_domain_connection_policy](https://registry.terraform.io/providers/AviatrixSystems/aviatrix/latest/docs/resources/segmentation_security_domain_connection_policy) | resource |
| [aviatrix_spoke_gateway.azure_spoke_gateway](https://registry.terraform.io/providers/AviatrixSystems/aviatrix/latest/docs/resources/spoke_gateway) | resource |
| [aviatrix_spoke_transit_attachment.attach_spoke](https://registry.terraform.io/providers/AviatrixSystems/aviatrix/latest/docs/resources/spoke_transit_attachment) | resource |
| [aviatrix_transit_firenet_policy.spoke_transit_firenet_policy](https://registry.terraform.io/providers/AviatrixSystems/aviatrix/latest/docs/resources/transit_firenet_policy) | resource |
| [azurerm_dev_test_global_vm_shutdown_schedule.gateway_shutdown](https://registry.terraform.io/providers/hashicorp/azurerm/2.89.0/docs/resources/dev_test_global_vm_shutdown_schedule) | resource |
| [azurerm_dev_test_global_vm_shutdown_schedule.vm_shutdown](https://registry.terraform.io/providers/hashicorp/azurerm/2.89.0/docs/resources/dev_test_global_vm_shutdown_schedule) | resource |
| [azurerm_key_vault_secret.vm1_secret](https://registry.terraform.io/providers/hashicorp/azurerm/2.89.0/docs/resources/key_vault_secret) | resource |
| [azurerm_linux_virtual_machine.virtual_machine1](https://registry.terraform.io/providers/hashicorp/azurerm/2.89.0/docs/resources/linux_virtual_machine) | resource |
| [azurerm_network_interface.virtual_machine1_nic1](https://registry.terraform.io/providers/hashicorp/azurerm/2.89.0/docs/resources/network_interface) | resource |
| [azurerm_public_ip.azure_gateway_public_ip](https://registry.terraform.io/providers/hashicorp/azurerm/2.89.0/docs/resources/public_ip) | resource |
| [azurerm_resource_group.azure_spoke_resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/2.89.0/docs/resources/resource_group) | resource |
| [azurerm_route_table.virtual_machine_route_table](https://registry.terraform.io/providers/hashicorp/azurerm/2.89.0/docs/resources/route_table) | resource |
| [azurerm_storage_account.spoke_storage_account](https://registry.terraform.io/providers/hashicorp/azurerm/2.89.0/docs/resources/storage_account) | resource |
| [azurerm_subnet.azure_spoke_gateway_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/2.89.0/docs/resources/subnet) | resource |
| [azurerm_subnet.azure_virtual_machines_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/2.89.0/docs/resources/subnet) | resource |
| [azurerm_subnet_route_table_association.virtual_machine_rtb_association](https://registry.terraform.io/providers/hashicorp/azurerm/2.89.0/docs/resources/subnet_route_table_association) | resource |
| [azurerm_virtual_network.azure_spoke_vnet](https://registry.terraform.io/providers/hashicorp/azurerm/2.89.0/docs/resources/virtual_network) | resource |
| [random_password.generate_vm1_secret](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [azurerm_virtual_machine.gateway_vm_data](https://registry.terraform.io/providers/hashicorp/azurerm/2.89.0/docs/data-sources/virtual_machine) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aviatrix_azure_account"></a> [aviatrix\_azure\_account](#input\_aviatrix\_azure\_account) | The name of the account configured in the Aviatrix Controller. | `string` | n/a | yes |
| <a name="input_controller_password"></a> [controller\_password](#input\_controller\_password) | The controllers password. | `string` | n/a | yes |
| <a name="input_controller_public_ip"></a> [controller\_public\_ip](#input\_controller\_public\_ip) | The controllers public IP address. | `string` | `"1.2.3.4"` | no |
| <a name="input_controller_username"></a> [controller\_username](#input\_controller\_username) | The controllers username. | `string` | `"admin"` | no |
| <a name="input_firenet_inspection"></a> [firenet\_inspection](#input\_firenet\_inspection) | Tells the subnet to be inspected by firewalls if configured | `bool` | `false` | no |
| <a name="input_gateway_subnet_address_prefix"></a> [gateway\_subnet\_address\_prefix](#input\_gateway\_subnet\_address\_prefix) | The address prefix for gateway subnet in vnet. | `string` | n/a | yes |
| <a name="input_key_vault_id"></a> [key\_vault\_id](#input\_key\_vault\_id) | The key vault id where the virtual machine secret will be stored. | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The location used for deployment of resources. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The resource group name to be created. | `string` | `"test-resource-group"` | no |
| <a name="input_segmentation_domain_connection_policies"></a> [segmentation\_domain\_connection\_policies](#input\_segmentation\_domain\_connection\_policies) | The segementation domain connection policies to associate to the spoke. | `list(string)` | n/a | yes |
| <a name="input_segmentation_domain_name"></a> [segmentation\_domain\_name](#input\_segmentation\_domain\_name) | The segmentation domain name | `string` | n/a | yes |
| <a name="input_spoke_gateway_name"></a> [spoke\_gateway\_name](#input\_spoke\_gateway\_name) | The name used for the spoke gateway resource | `string` | n/a | yes |
| <a name="input_spoke_gw_size"></a> [spoke\_gw\_size](#input\_spoke\_gw\_size) | The size of the transit gateways | `string` | `"Standard_B1ms"` | no |
| <a name="input_storage_account_name"></a> [storage\_account\_name](#input\_storage\_account\_name) | The name of the storage account. | `string` | n/a | yes |
| <a name="input_test_vm_name"></a> [test\_vm\_name](#input\_test\_vm\_name) | The name used for the test virtual machine resource | `string` | n/a | yes |
| <a name="input_transit_gateway_name"></a> [transit\_gateway\_name](#input\_transit\_gateway\_name) | The transit gateway name the spoke will be peered with. | `string` | n/a | yes |
| <a name="input_virtual_machines_subnet_address_prefix"></a> [virtual\_machines\_subnet\_address\_prefix](#input\_virtual\_machines\_subnet\_address\_prefix) | The address prefix for virtual machines subnet in vnet. | `string` | n/a | yes |
| <a name="input_vnet_address_prefix"></a> [vnet\_address\_prefix](#input\_vnet\_address\_prefix) | The address prefix used for the virtual network. | `string` | n/a | yes |
| <a name="input_vnet_name"></a> [vnet\_name](#input\_vnet\_name) | The name for the Virtual Network | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->