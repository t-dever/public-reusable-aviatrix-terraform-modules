<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_panos"></a> [panos](#requirement\_panos) | 1.8.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_null"></a> [null](#provider\_null) | n/a |
| <a name="provider_panos"></a> [panos](#provider\_panos) | 1.8.3 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [null_resource.commit_configuration](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [panos_ethernet_interface.ethernet_1](https://registry.terraform.io/providers/PaloAltoNetworks/panos/1.8.3/docs/resources/ethernet_interface) | resource |
| [panos_ethernet_interface.ethernet_2](https://registry.terraform.io/providers/PaloAltoNetworks/panos/1.8.3/docs/resources/ethernet_interface) | resource |
| [panos_management_profile.allow_health_probes](https://registry.terraform.io/providers/PaloAltoNetworks/panos/1.8.3/docs/resources/management_profile) | resource |
| [panos_security_policy.allow_all](https://registry.terraform.io/providers/PaloAltoNetworks/panos/1.8.3/docs/resources/security_policy) | resource |
| [panos_virtual_router.default_virtual_router](https://registry.terraform.io/providers/PaloAltoNetworks/panos/1.8.3/docs/resources/virtual_router) | resource |
| [panos_zone.lan_zone](https://registry.terraform.io/providers/PaloAltoNetworks/panos/1.8.3/docs/resources/zone) | resource |
| [panos_zone.wan_zone](https://registry.terraform.io/providers/PaloAltoNetworks/panos/1.8.3/docs/resources/zone) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_palo_ip_address"></a> [palo\_ip\_address](#input\_palo\_ip\_address) | The IP Address of the Palo Alto Firewall. | `string` | n/a | yes |
| <a name="input_palo_password"></a> [palo\_password](#input\_palo\_password) | The Palo Alto Firewall password. | `string` | n/a | yes |
| <a name="input_palo_username"></a> [palo\_username](#input\_palo\_username) | The Palo Alto Firewall username. | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->