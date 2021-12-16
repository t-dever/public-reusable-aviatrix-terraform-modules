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
<!-- END_TF_DOCS -->