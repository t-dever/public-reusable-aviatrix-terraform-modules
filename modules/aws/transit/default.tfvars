region                                       = "us-east-1"
tag_prefix                                   = "aviatrix"
tags                                         = {}
vpc_name                                     = "aviatrix-transit-vpc"
vpc_address_space                            = "10.0.0.0/23"
aviatrix_transit_primary_subnet_name         = "aviatrix-transit-primary"
aviatrix_transit_ha_subnet_name              = "aviatrix-transit-ha"
aviatrix_firewall_mgmt_primary_subnet_name   = "aviatrix-firewall-mgmt-primary"
aviatrix_firewall_mgmt_ha_subnet_name        = "aviatrix-firewall-mgmt-ha"
aviatrix_firewall_egress_primary_subnet_name = "aviatrix-firewall-egress-primary"
aviatrix_firewall_egress_ha_subnet_name      = "aviatrix-firewall-egress-ha"
aviatrix_transit_availability_zone_1         = "us-east-1a"
aviatrix_transit_availability_zone_2         = "us-east-1b"
aviatrix_access_account_name                 = "<Name for access account in aviatrix controller>" # REQUIRED
insane_mode                                  = false
aviatrix_transit_gateway_name                = "aviatrix-transit-gw"
aviatrix_transit_gateway_size                = "t2.large" # "c5.xlarge" for insane mode & firenet
enable_aviatrix_transit_gateway_ha           = false
enable_aviatrix_transit_firenet              = false
enable_firenet_egress                        = false
firewall_mgmt_security_group_name            = "aviatrix-firewall-mgmt-security-group"
firewall_allowed_ips                         = []
firewall_image                               = "Palo Alto Networks VM-Series Next-Generation Firewall Bundle 1"
firewall_image_version                       = "10.1.4"
firewall_aws_key_pair_name                   = "aviatrix-firenet-key"
firewall_public_key                          = "<Public SSH Key"                                              # Required for deploying firewalls
firewall_private_key_location                = "<file location for private key on machine running terraform>" # Required for deploying firewalls
firewalls                                    = [
    {
        name = "firewall-1",
        size = "m5.xlarge"
    }
]
s3_bucket_name                               = ""
s3_iam_role_name                             = "aviatrix-s3-bootstrap-role"
