<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aviatrix"></a> [aviatrix](#requirement\_aviatrix) | 2.21.2 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 4.4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aviatrix"></a> [aviatrix](#provider\_aviatrix) | 2.21.2 |
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.4.0 |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aviatrix_firewall_instance.firewall_instance](https://registry.terraform.io/providers/AviatrixSystems/aviatrix/2.21.2/docs/resources/firewall_instance) | resource |
| [aviatrix_firewall_instance_association.firewall_instance_association](https://registry.terraform.io/providers/AviatrixSystems/aviatrix/2.21.2/docs/resources/firewall_instance_association) | resource |
| [aws_iam_instance_profile.aviatrix_bootstrap_profile](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/iam_instance_profile) | resource |
| [aws_iam_policy.aviatrix_s3_bootstrap_policy](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/iam_policy) | resource |
| [aws_iam_role.aviatrix_s3_bootstrap_role](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.aviatrix_bootstrap_role_attach](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_key_pair.key_pair](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/key_pair) | resource |
| [aws_s3_bucket.s3_bucket](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_acl.s3_acl](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_bucket_logging.s3_logging](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/s3_bucket_logging) | resource |
| [aws_s3_bucket_public_access_block.s3_block_public_access](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.s3_encryption](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.s3_versioning](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/s3_bucket_versioning) | resource |
| [aws_s3_object.bootstrap_content](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/s3_object) | resource |
| [aws_s3_object.bootstrap_license](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/s3_object) | resource |
| [aws_s3_object.bootstrap_software](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/s3_object) | resource |
| [aws_s3_object.bootstrap_upload](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/s3_object) | resource |
| [aws_s3_object.cfg_upload](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/s3_object) | resource |
| [aws_ssm_parameter.aviatrix_palo_alto_secret_parameter](https://registry.terraform.io/providers/hashicorp/aws/4.4.0/docs/resources/ssm_parameter) | resource |
| [null_resource.initial_config](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [random_id.s3_bucket_random_id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [random_password.aviatrix_firewall_admin_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [aviatrix_firenet_vendor_integration.vendor_integration](https://registry.terraform.io/providers/AviatrixSystems/aviatrix/2.21.2/docs/data-sources/firenet_vendor_integration) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aviatrix_transit_ha_gateway_name"></a> [aviatrix\_transit\_ha\_gateway\_name](#input\_aviatrix\_transit\_ha\_gateway\_name) | The name of the primary transit gateway. | `string` | n/a | yes |
| <a name="input_aviatrix_transit_primary_gateway_name"></a> [aviatrix\_transit\_primary\_gateway\_name](#input\_aviatrix\_transit\_primary\_gateway\_name) | The name of the primary transit gateway. | `string` | n/a | yes |
| <a name="input_aws_firewall_key_pair_name"></a> [aws\_firewall\_key\_pair\_name](#input\_aws\_firewall\_key\_pair\_name) | The key pair name to be used for Firewall EC2 Instance Deployments. | `string` | `"aviatrix-firenet-key"` | no |
| <a name="input_aws_key_pair_public_key"></a> [aws\_key\_pair\_public\_key](#input\_aws\_key\_pair\_public\_key) | The key pair public ssh key to be used for EC2 Instance Deployments. | `string` | n/a | yes |
| <a name="input_aws_vpc_id"></a> [aws\_vpc\_id](#input\_aws\_vpc\_id) | The VPC ID used for firewall instance. | `string` | n/a | yes |
| <a name="input_firewall_egress_ha_subnet"></a> [firewall\_egress\_ha\_subnet](#input\_firewall\_egress\_ha\_subnet) | The ha subnet for firewall egress. | `string` | n/a | yes |
| <a name="input_firewall_egress_primary_subnet"></a> [firewall\_egress\_primary\_subnet](#input\_firewall\_egress\_primary\_subnet) | The primary subnet for firewall egress. | `string` | n/a | yes |
| <a name="input_firewall_image"></a> [firewall\_image](#input\_firewall\_image) | The firewall image to be used to deploy the NGFW's | `string` | `"Palo Alto Networks VM-Series Next-Generation Firewall Bundle 1"` | no |
| <a name="input_firewall_image_version"></a> [firewall\_image\_version](#input\_firewall\_image\_version) | The firewall image version specific to the NGFW vendor image | `string` | `"10.1.4"` | no |
| <a name="input_firewall_mgmt_ha_subnet"></a> [firewall\_mgmt\_ha\_subnet](#input\_firewall\_mgmt\_ha\_subnet) | The ha subnet for firewall management. | `string` | n/a | yes |
| <a name="input_firewall_mgmt_primary_subnet"></a> [firewall\_mgmt\_primary\_subnet](#input\_firewall\_mgmt\_primary\_subnet) | The primary subnet for firewall management. | `string` | n/a | yes |
| <a name="input_firewall_password"></a> [firewall\_password](#input\_firewall\_password) | Password used for the admin user of the firewall. If not provided then password will be autogenerated and stored in AWS Systems Manager Parameter Store. | `string` | `""` | no |
| <a name="input_firewall_private_key_location"></a> [firewall\_private\_key\_location](#input\_firewall\_private\_key\_location) | The location of the private key on the local machine to authenticate to palo firewall to change admin credentials. | `string` | `""` | no |
| <a name="input_firewall_size"></a> [firewall\_size](#input\_firewall\_size) | The firewall ec2 instance size. | `string` | `"m5.xlarge"` | no |
| <a name="input_firewalls"></a> [firewalls](#input\_firewalls) | The firewall instance information required for creating firewalls | <pre>list(object({<br>    name = string<br>  }))</pre> | `[]` | no |
| <a name="input_s3_bucket_name"></a> [s3\_bucket\_name](#input\_s3\_bucket\_name) | The name of the S3 Bucket to store Firewall Bootstrap. | `string` | `""` | no |
| <a name="input_s3_iam_role_name"></a> [s3\_iam\_role\_name](#input\_s3\_iam\_role\_name) | The name of the iam role used to access S3 Bucket. | `string` | `"aviatrix-s3-bootstrap-role"` | no |
| <a name="input_store_firewall_password_in_ssm"></a> [store\_firewall\_password\_in\_ssm](#input\_store\_firewall\_password\_in\_ssm) | Gives the option to store the firewall password in AWS Systems Manager Parameter Store to access. | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bootstrap_bucket_name"></a> [bootstrap\_bucket\_name](#output\_bootstrap\_bucket\_name) | The name of the bootstrap bucket. |
| <a name="output_firewall_admin_username"></a> [firewall\_admin\_username](#output\_firewall\_admin\_username) | The firewall admin username added to the firewall. |
| <a name="output_firewall_management_interface_ids"></a> [firewall\_management\_interface\_ids](#output\_firewall\_management\_interface\_ids) | List of the firewall management network interface IDs |
| <a name="output_firewall_password"></a> [firewall\_password](#output\_firewall\_password) | The value of the randomly generated secret. |
| <a name="output_palo_alto_iam_id"></a> [palo\_alto\_iam\_id](#output\_palo\_alto\_iam\_id) | The ID of the IAM role for S3 Bucket Access. |
<!-- END_TF_DOCS -->