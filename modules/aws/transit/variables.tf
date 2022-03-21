variable "region" {
  description = "The region where the resources will be deployed."
  type        = string
  default     = "us-east-1"
}

variable "tags" {
  description = "The tags used for resources."
  type        = map(any)
  default     = {}
}

variable "tag_prefix" {
  description = "The prefix of tagged resource names."
  type        = string
  default     = "aviatrix"
}

variable "insane_mode" {
  type        = bool
  description = "Enable insane mode for transit gateway."
  default     = false
}

variable "vpc_name" {
  description = "The name of the VPC."
  type        = string
  default     = "aviatrix-transit-vpc"
}

variable "vpc_address_space" {
  description = "The address space used for the VPC."
  type        = string
  default     = "10.0.0.0/24"
}

variable "aviatrix_transit_primary_subnet_name" {
  description = "The name of the Primary Aviatrix Transit Gateway Subnet."
  type        = string
  default     = "aviatrix-transit-primary"
}

variable "aviatrix_transit_ha_subnet_name" {
  description = "The name of the HA Aviatrix Transit Gateway Subnet."
  type        = string
  default     = "aviatrix-transit-ha"
}

variable "aviatrix_firewall_mgmt_primary_subnet_name" {
  description = "The name of the Primary Firewall Management Subnet."
  type        = string
  default     = "aviatrix-firewall-mgmt-primary"
}

variable "aviatrix_firewall_mgmt_ha_subnet_name" {
  description = "The name of the HA Firewall Management Subnet."
  type        = string
  default     = "aviatrix-firewall-mgmt-ha"
}

variable "aviatrix_firewall_egress_primary_subnet_name" {
  description = "The name of the Primary Firewall Egress Subnet."
  type        = string
  default     = "aviatrix-firewall-egress-primary"
}

variable "aviatrix_firewall_egress_ha_subnet_name" {
  description = "The name of the HA Firewall Egress Subnet."
  type        = string
  default     = "aviatrix-firewall-egress-ha"
}


variable "aviatrix_transit_availability_zone_1" {
  description = "The availability zone for Primary Aviatrix Transit Gateway"
  type        = string
  default     = ""
}

variable "aviatrix_transit_availability_zone_2" {
  description = "The availability zone for HA Aviatrix Transit Gateway"
  type        = string
  default     = ""
}

variable "aviatrix_access_account_name" {
  description = "The name of the access account to be used in the Aviatrix Controller for deployment of Transit Gateways."
  type        = string
}

variable "aviatrix_transit_gateway_name" {
  type        = string
  description = "The name used for the transit gateway resource"
}

variable "aviatrix_transit_gateway_size" {
  type        = string
  description = "The size of the transit gateways"
  default     = "t2.large"
}

variable "enable_aviatrix_transit_gateway_ha" {
  type        = bool
  description = "Enable High Availability (HA) for transit gateways"
  default     = false
}

variable "enable_aviatrix_transit_firenet" {
  description = "Enables firenet on the aviatrix transit gateway"
  type        = bool
  default     = false
}

variable "enable_firenet_egress" {
  type        = bool
  default     = false
  description = "Allow traffic to the internet through firewall."
}

variable "firewall_name" {
  description = "The name of the firewall to be deployed."
  type        = string
  default     = ""
}

variable "firewall_mgmt_security_group_name" {
  description = "The name of the Security Group for Firewall Management."
  type = string
  default = "aviatrix-firewall-mgmt-security-group"
}

variable "firewall_image" {
  type        = string
  description = "The firewall image to be used to deploy the NGFW's"
  default     = ""
  validation {
    condition     = contains(["Palo Alto Networks VM-Series Next-Generation Firewall Bundle 1", ""], var.firewall_image)
    error_message = "The firewall_image must be one of values in the condition statement."
  }
}

variable "allowed_ips" {
  description = "List of allowed User Public Ips to be added as ingress rule for security group."
  type        = list(string)
  default     = []
}

variable "firewall_image_version" {
  description = "The firewall image version specific to the NGFW vendor image"
  type        = string
  default     = ""
}

variable "firewalls" {
  description = "The firewall instance information required for creating firewalls"
  type = list(object({
    name              = string,
    size              = string,
    availability_zone = string,
  }))
}


# variable "resource_group_name" {
#   description = "The resource group name to be created."
#   type        = string
#   default     = "test-resource-group"
# }

# variable "location" {
#   description = "Location of the resource group"
#   type        = string
#   default     = "South Central US"
# }

# variable "vnet_name" {
#   type        = string
#   description = "The name for the Virtual Network"
# }

# variable "vnet_address_prefix" {
#   description = "The address prefix used in the vnet"
#   type        = string
#   default     = "10.0.0.0/23"
# }

# variable "transit_gateway_name" {
#   type        = string
#   description = "The name used for the transit gateway resource"
# }

# variable "transit_gw_size" {
#   type        = string
#   description = "The size of the transit gateways"
#   default     = "Standard_B2ms"
# }

# variable "transit_gateway_ha" {
#   type        = bool
#   description = "Enable High Availability (HA) for transit gateways"
#   default     = false
# }

# variable "transit_gateway_az_zone" {
#   type        = string
#   description = "The availability zone for the primary transit gateway"
#   default     = "az-1"
# }

# variable "transit_gateway_ha_az_zone" {
#   type        = string
#   description = "The availability zone for the ha transit gateway"
#   default     = "az-2"
# }

# variable "enable_transit_gateway_scheduled_shutdown" {
#   type        = bool
#   description = "Enable automatic shutdown on transit gateway."
#   default     = false
# }

# variable "insane_mode" {
#   type        = bool
#   description = "Enable insane mode for transit gateway."
#   default     = false
# }

# variable "aviatrix_azure_account" {
#   description = "The account used to manage the transit gateway"
#   type        = string
#   sensitive   = true
#   default     = "test-account"
# }
# variable "key_vault_id" {
#   description = "The key vault id used to store the firewall password"
#   type        = string
#   sensitive   = true
#   default     = "default"
# }

# variable "firenet_enabled" {
#   description = "Enables firenet on the aviatrix transit gateway"
#   type        = bool
#   default     = false
# }

# variable "firewall_image" {
#   type        = string
#   description = "The firewall image to be used to deploy the NGFW's"
#   default     = ""
# }

# variable "firewall_image_version" {
#   description = "The firewall image version specific to the NGFW vendor image"
#   type        = string
#   default     = ""
# }

# variable "fw_instance_size" {
#   description = "Azure Instance size for the NGFW's"
#   type        = string
#   default     = "Standard_D3_v2"
# }

# variable "firewall_name" {
#   description = "The name of the firewall to be deployed."
#   type        = string
# }

# variable "firewall_ha" {
#   description = "Enables firewall High Availability by creating two firewalls in separate availability zones"
#   type        = bool
#   default     = false
# }

# variable "firewall_username" {
#   type        = string
#   description = "The username used for the firewall configurations"
#   default     = "fwadmin"
# }



# variable "allowed_public_ips" {
#   description = "A list of allowed public IP's access to firewalls."
#   type        = list(string)
#   default     = []
#   sensitive   = true
# }

locals {
  # is_checkpoint             = length(regexall("check", lower(var.firewall_image))) > 0    # Check if fw image contains checkpoint.
  is_palo = length(regexall("palo", lower(var.firewall_image))) > 0 # Check if fw image contains palo.
  # is_fortinet               = length(regexall("fortinet", lower(var.firewall_image))) > 0 # Check if fw image contains fortinet.
  is_aws_gov              = length(regexall("gov", var.region)) > 0 ? true : false
  cidrbits                = tonumber(split("/", var.vpc_address_space)[1])
  transit_gateway_newbits = var.insane_mode ? 26 - local.cidrbits : 28 - local.cidrbits
  firewall_subnet_newbits = 28 - local.cidrbits
  netnum                  = pow(2, local.transit_gateway_newbits)
  # firewall_newbits          = 28 - local.cidrbits
  combined_cidr_subnets          = cidrsubnets(var.vpc_address_space, local.transit_gateway_newbits, local.transit_gateway_newbits, local.firewall_subnet_newbits, local.firewall_subnet_newbits, local.firewall_subnet_newbits, local.firewall_subnet_newbits)
  transit_gateway_subnet         = local.combined_cidr_subnets[0]
  transit_gateway_ha_subnet      = local.combined_cidr_subnets[1]
  firewall_mgmt_primary_subnet   = local.combined_cidr_subnets[2]
  firewall_mgmt_ha_subnet        = local.combined_cidr_subnets[3]
  firewall_egress_primary_subnet = local.combined_cidr_subnets[4]
  firewall_egress_ha_subnet      = local.combined_cidr_subnets[5]
  # transit_gateway_subnet    = cidrsubnet(var.vpc_address_space, local.transit_gateway_newbits, local.netnum - 2)
  # transit_gateway_ha_subnet = cidrsubnet(var.vpc_address_space, local.transit_gateway_newbits, local.netnum - 1)
  # firewall_subnet           = cidrsubnet(var.vnet_address_prefix, local.firewall_newbits, 0)
  # firewall_wan_gateway      = cidrhost(local.firewall_subnet, 1)
  # fortinet_bootstrap        = local.is_fortinet && var.egress_enabled ? templatefile("${path.module}/firewalls/fortinet/fortinet_egress_init.tftpl", { wan_gateway = local.firewall_wan_gateway }) : templatefile("${path.module}/firewalls/fortinet/fortinet_init.tftpl")
}
