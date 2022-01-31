# hub

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
| [aviatrix_firenet.firenet](https://registry.terraform.io/providers/AviatrixSystems/aviatrix/2.20.1/docs/resources/firenet) | resource |
| [aviatrix_firewall_instance.palo_firewall_instance](https://registry.terraform.io/providers/AviatrixSystems/aviatrix/2.20.1/docs/resources/firewall_instance) | resource |
| [aviatrix_firewall_instance_association.firewall_instance_association_1](https://registry.terraform.io/providers/AviatrixSystems/aviatrix/2.20.1/docs/resources/firewall_instance_association) | resource |
| [aviatrix_transit_gateway.azure_transit_gateway](https://registry.terraform.io/providers/AviatrixSystems/aviatrix/2.20.1/docs/resources/transit_gateway) | resource |
| [azurerm_dev_test_global_vm_shutdown_schedule.transit_shutdown](https://registry.terraform.io/providers/hashicorp/azurerm/2.80.0/docs/resources/dev_test_global_vm_shutdown_schedule) | resource |
| [azurerm_key_vault_secret.firewall_secret](https://registry.terraform.io/providers/hashicorp/azurerm/2.80.0/docs/resources/key_vault_secret) | resource |
| [azurerm_network_security_rule.palo_allow_controller_mgmt_nsg_inbound](https://registry.terraform.io/providers/hashicorp/azurerm/2.80.0/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.palo_allow_user_mgmt_nsg_inbound](https://registry.terraform.io/providers/hashicorp/azurerm/2.80.0/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.palo_deny_mgmt_nsg_inbound](https://registry.terraform.io/providers/hashicorp/azurerm/2.80.0/docs/resources/network_security_rule) | resource |
| [azurerm_public_ip.azure_gateway_public_ip](https://registry.terraform.io/providers/hashicorp/azurerm/2.80.0/docs/resources/public_ip) | resource |
| [azurerm_resource_group.azure_hub_resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/2.80.0/docs/resources/resource_group) | resource |
| [azurerm_storage_account.storage_account](https://registry.terraform.io/providers/hashicorp/azurerm/2.80.0/docs/resources/storage_account) | resource |
| [azurerm_subnet.azure_hub_firewall_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/2.80.0/docs/resources/subnet) | resource |
| [azurerm_subnet.azure_hub_gateway_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/2.80.0/docs/resources/subnet) | resource |
| [azurerm_virtual_network.azure_hub_vnet](https://registry.terraform.io/providers/hashicorp/azurerm/2.80.0/docs/resources/virtual_network) | resource |
| [random_password.generate_firewall_secret](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/2.80.0/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aviatrix_azure_account"></a> [aviatrix\_azure\_account](#input\_aviatrix\_azure\_account) | The account used to manage the transit gateway | `string` | `"test-account"` | no |
| <a name="input_controller_admin_password"></a> [controller\_admin\_password](#input\_controller\_admin\_password) | The controllers admin password | `string` | `"1.1.1.1"` | no |
| <a name="input_controller_public_ip"></a> [controller\_public\_ip](#input\_controller\_public\_ip) | The controllers public IP address. | `string` | `"1.2.3.4"` | no |
| <a name="input_firenet_enabled"></a> [firenet\_enabled](#input\_firenet\_enabled) | Enables firenet on the aviatrix transit gateway | `bool` | `false` | no |
| <a name="input_firewall_ingress_egress_prefix"></a> [firewall\_ingress\_egress\_prefix](#input\_firewall\_ingress\_egress\_prefix) | The subnet address prefix used for the firewall ingress and egress | `string` | `"10.0.1.0/24"` | no |
| <a name="input_gateway_mgmt_subnet_address_prefix"></a> [gateway\_mgmt\_subnet\_address\_prefix](#input\_gateway\_mgmt\_subnet\_address\_prefix) | The subnet address prefix used for the gateway management ip | `string` | `"10.0.0.0/24"` | no |
| <a name="input_key_vault_id"></a> [key\_vault\_id](#input\_key\_vault\_id) | The key vault id used to store the firewall password | `string` | `"default"` | no |
| <a name="input_location"></a> [location](#input\_location) | Location of the resource group | `string` | `"South Central US"` | no |
| <a name="input_resource_prefix"></a> [resource\_prefix](#input\_resource\_prefix) | The prefix to the resource group that will be used for all created resources | `string` | `"test-resource-group"` | no |
| <a name="input_user_public_for_mgmt"></a> [user\_public\_for\_mgmt](#input\_user\_public\_for\_mgmt) | The public IP address of the user that is logging into the controller | `string` | `"1.1.1.1"` | no |
| <a name="input_vnet_address_prefix"></a> [vnet\_address\_prefix](#input\_vnet\_address\_prefix) | The address prefix used in the vnet | `string` | `"10.0.0.0/23"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_firewall_mgmt_ip"></a> [firewall\_mgmt\_ip](#output\_firewall\_mgmt\_ip) | The public IP addresses for firewalls |
| <a name="output_hub_address_prefix"></a> [hub\_address\_prefix](#output\_hub\_address\_prefix) | The hub vnet address space |
| <a name="output_hub_resource_group_name"></a> [hub\_resource\_group\_name](#output\_hub\_resource\_group\_name) | The hub resource group name |
| <a name="output_hub_vnet_name"></a> [hub\_vnet\_name](#output\_hub\_vnet\_name) | The hub vnet name |
| <a name="output_transit_gateway_name"></a> [transit\_gateway\_name](#output\_transit\_gateway\_name) | The transit gateway name |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aviatrix"></a> [aviatrix](#requirement\_aviatrix) | 2.21.0-6.6.ga |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 2.89.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aviatrix"></a> [aviatrix](#provider\_aviatrix) | 2.21.0-6.6.ga |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 2.89.0 |
| <a name="provider_external"></a> [external](#provider\_external) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aviatrix_firenet.firenet](https://registry.terraform.io/providers/AviatrixSystems/aviatrix/2.21.0-6.6.ga/docs/resources/firenet) | resource |
| [aviatrix_firewall_instance.firewall_instance_1](https://registry.terraform.io/providers/AviatrixSystems/aviatrix/2.21.0-6.6.ga/docs/resources/firewall_instance) | resource |
| [aviatrix_firewall_instance.firewall_instance_2](https://registry.terraform.io/providers/AviatrixSystems/aviatrix/2.21.0-6.6.ga/docs/resources/firewall_instance) | resource |
| [aviatrix_firewall_instance_association.firewall_instance_association_1](https://registry.terraform.io/providers/AviatrixSystems/aviatrix/2.21.0-6.6.ga/docs/resources/firewall_instance_association) | resource |
| [aviatrix_firewall_instance_association.firewall_instance_association_2](https://registry.terraform.io/providers/AviatrixSystems/aviatrix/2.21.0-6.6.ga/docs/resources/firewall_instance_association) | resource |
| [aviatrix_transit_gateway.azure_transit_gateway](https://registry.terraform.io/providers/AviatrixSystems/aviatrix/2.21.0-6.6.ga/docs/resources/transit_gateway) | resource |
| [azurerm_dev_test_global_vm_shutdown_schedule.transit_shutdown](https://registry.terraform.io/providers/hashicorp/azurerm/2.89.0/docs/resources/dev_test_global_vm_shutdown_schedule) | resource |
| [azurerm_dev_test_global_vm_shutdown_schedule.transit_shutdown_1](https://registry.terraform.io/providers/hashicorp/azurerm/2.89.0/docs/resources/dev_test_global_vm_shutdown_schedule) | resource |
| [azurerm_key_vault_secret.firewall_secret](https://registry.terraform.io/providers/hashicorp/azurerm/2.89.0/docs/resources/key_vault_secret) | resource |
| [azurerm_network_security_group.firewall_mgmt_nsg](https://registry.terraform.io/providers/hashicorp/azurerm/2.89.0/docs/resources/network_security_group) | resource |
| [azurerm_network_security_rule.allow_user_and_controller_inbound_to_firewall_mgmt](https://registry.terraform.io/providers/hashicorp/azurerm/2.89.0/docs/resources/network_security_rule) | resource |
| [azurerm_public_ip.transit_hagw_public_ip](https://registry.terraform.io/providers/hashicorp/azurerm/2.89.0/docs/resources/public_ip) | resource |
| [azurerm_public_ip.transit_public_ip](https://registry.terraform.io/providers/hashicorp/azurerm/2.89.0/docs/resources/public_ip) | resource |
| [azurerm_resource_group.azure_transit_resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/2.89.0/docs/resources/resource_group) | resource |
| [azurerm_subnet.azure_transit_firewall_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/2.89.0/docs/resources/subnet) | resource |
| [azurerm_subnet.transit_gw_ha_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/2.89.0/docs/resources/subnet) | resource |
| [azurerm_subnet.transit_gw_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/2.89.0/docs/resources/subnet) | resource |
| [azurerm_subnet_network_security_group_association.firewall_mgmt_nsg_association](https://registry.terraform.io/providers/hashicorp/azurerm/2.89.0/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_virtual_network.azure_transit_vnet](https://registry.terraform.io/providers/hashicorp/azurerm/2.89.0/docs/resources/virtual_network) | resource |
| [random_password.generate_firewall_secret](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [aviatrix_firenet_vendor_integration.vendor_integration_1](https://registry.terraform.io/providers/AviatrixSystems/aviatrix/2.21.0-6.6.ga/docs/data-sources/firenet_vendor_integration) | data source |
| [aviatrix_firenet_vendor_integration.vendor_integration_2](https://registry.terraform.io/providers/AviatrixSystems/aviatrix/2.21.0-6.6.ga/docs/data-sources/firenet_vendor_integration) | data source |
| [aviatrix_transit_gateway.transit_gw_data](https://registry.terraform.io/providers/AviatrixSystems/aviatrix/2.21.0-6.6.ga/docs/data-sources/transit_gateway) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/2.89.0/docs/data-sources/client_config) | data source |
| [external_external.fortinet_bootstrap_1](https://registry.terraform.io/providers/hashicorp/external/latest/docs/data-sources/external) | data source |
| [external_external.fortinet_bootstrap_2](https://registry.terraform.io/providers/hashicorp/external/latest/docs/data-sources/external) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_public_ips"></a> [allowed\_public\_ips](#input\_allowed\_public\_ips) | A list of allowed public IP's access to firewalls. | `list(string)` | `[]` | no |
| <a name="input_aviatrix_azure_account"></a> [aviatrix\_azure\_account](#input\_aviatrix\_azure\_account) | The account used to manage the transit gateway | `string` | `"test-account"` | no |
| <a name="input_controller_password"></a> [controller\_password](#input\_controller\_password) | The controllers password. | `string` | n/a | yes |
| <a name="input_controller_public_ip"></a> [controller\_public\_ip](#input\_controller\_public\_ip) | The controllers public IP address. | `string` | `"1.2.3.4"` | no |
| <a name="input_controller_username"></a> [controller\_username](#input\_controller\_username) | The controllers username. | `string` | `"admin"` | no |
| <a name="input_egress_enabled"></a> [egress\_enabled](#input\_egress\_enabled) | Allow traffic to the internet through firewall | `bool` | `false` | no |
| <a name="input_enable_transit_gateway_scheduled_shutdown"></a> [enable\_transit\_gateway\_scheduled\_shutdown](#input\_enable\_transit\_gateway\_scheduled\_shutdown) | Enable automatic shutdown on transit gateway. | `bool` | `false` | no |
| <a name="input_firenet_enabled"></a> [firenet\_enabled](#input\_firenet\_enabled) | Enables firenet on the aviatrix transit gateway | `bool` | `false` | no |
| <a name="input_firewall_ha"></a> [firewall\_ha](#input\_firewall\_ha) | Enables firewall High Availability by creating two firewalls in separate availability zones | `bool` | `false` | no |
| <a name="input_firewall_image"></a> [firewall\_image](#input\_firewall\_image) | The firewall image to be used to deploy the NGFW's | `string` | `""` | no |
| <a name="input_firewall_image_version"></a> [firewall\_image\_version](#input\_firewall\_image\_version) | The firewall image version specific to the NGFW vendor image | `string` | `""` | no |
| <a name="input_firewall_name"></a> [firewall\_name](#input\_firewall\_name) | The name of the firewall to be deployed. | `string` | n/a | yes |
| <a name="input_firewall_username"></a> [firewall\_username](#input\_firewall\_username) | The username used for the firewall configurations | `string` | `"fwadmin"` | no |
| <a name="input_fw_instance_size"></a> [fw\_instance\_size](#input\_fw\_instance\_size) | Azure Instance size for the NGFW's | `string` | `"Standard_D3_v2"` | no |
| <a name="input_insane_mode"></a> [insane\_mode](#input\_insane\_mode) | Enable insane mode for transit gateway. | `bool` | `false` | no |
| <a name="input_key_vault_id"></a> [key\_vault\_id](#input\_key\_vault\_id) | The key vault id used to store the firewall password | `string` | `"default"` | no |
| <a name="input_location"></a> [location](#input\_location) | Location of the resource group | `string` | `"South Central US"` | no |
| <a name="input_primary_subnet_size"></a> [primary\_subnet\_size](#input\_primary\_subnet\_size) | The cidr for the subnet used for virtual machines or other devices. | `number` | `28` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The resource group name to be created. | `string` | `"test-resource-group"` | no |
| <a name="input_secondary_ha_subnet_size"></a> [secondary\_ha\_subnet\_size](#input\_secondary\_ha\_subnet\_size) | The cidr for the subnet used for virtual machines or other devices for HA subnet. | `number` | `28` | no |
| <a name="input_transit_gateway_az_zone"></a> [transit\_gateway\_az\_zone](#input\_transit\_gateway\_az\_zone) | The availability zone for the primary transit gateway | `string` | `"az-1"` | no |
| <a name="input_transit_gateway_ha"></a> [transit\_gateway\_ha](#input\_transit\_gateway\_ha) | Enable High Availability (HA) for transit gateways | `bool` | `false` | no |
| <a name="input_transit_gateway_ha_az_zone"></a> [transit\_gateway\_ha\_az\_zone](#input\_transit\_gateway\_ha\_az\_zone) | The availability zone for the ha transit gateway | `string` | `"az-2"` | no |
| <a name="input_transit_gateway_name"></a> [transit\_gateway\_name](#input\_transit\_gateway\_name) | The name used for the transit gateway resource | `string` | n/a | yes |
| <a name="input_transit_gw_size"></a> [transit\_gw\_size](#input\_transit\_gw\_size) | The size of the transit gateways | `string` | `"Standard_B2ms"` | no |
| <a name="input_vnet_address_prefix"></a> [vnet\_address\_prefix](#input\_vnet\_address\_prefix) | The address prefix used in the vnet | `string` | `"10.0.0.0/23"` | no |
| <a name="input_vnet_name"></a> [vnet\_name](#input\_vnet\_name) | The name for the Virtual Network | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_firenet_enabled"></a> [firenet\_enabled](#output\_firenet\_enabled) | Outputs true if firenet is enabled, used to auto add spokes to firewall policy for inspection |
| <a name="output_firewall_1_api_key"></a> [firewall\_1\_api\_key](#output\_firewall\_1\_api\_key) | The API Key for fortinet firewall 1. |
| <a name="output_firewall_1_mgmt_ip"></a> [firewall\_1\_mgmt\_ip](#output\_firewall\_1\_mgmt\_ip) | The public IP address for firewall 1. |
| <a name="output_firewall_2_api_key"></a> [firewall\_2\_api\_key](#output\_firewall\_2\_api\_key) | The API Key for fortinet firewall 2. |
| <a name="output_firewall_2_mgmt_ip"></a> [firewall\_2\_mgmt\_ip](#output\_firewall\_2\_mgmt\_ip) | The public IP address for firewall 2. |
| <a name="output_firewall_password"></a> [firewall\_password](#output\_firewall\_password) | The generated firewall password. |
| <a name="output_firewall_username"></a> [firewall\_username](#output\_firewall\_username) | The username for the firewalls |
| <a name="output_transit_address_prefix"></a> [transit\_address\_prefix](#output\_transit\_address\_prefix) | The transit vnet address space |
| <a name="output_transit_gateway_name"></a> [transit\_gateway\_name](#output\_transit\_gateway\_name) | The transit gateway name |
| <a name="output_transit_resource_group_name"></a> [transit\_resource\_group\_name](#output\_transit\_resource\_group\_name) | The transit resource group name |
| <a name="output_transit_vnet_name"></a> [transit\_vnet\_name](#output\_transit\_vnet\_name) | The transit vnet name |
<!-- END_TF_DOCS -->