variable "controller_username" {
  description = "The controllers username."
  default     = "admin"
  type        = string
  sensitive   = true
}

variable "controller_password" {
  description = "The controllers password."
  type        = string
  sensitive   = true
}

variable "controller_public_ip" {
  description = "The controllers public IP address."
  default     = "1.2.3.4"
  type        = string
  sensitive   = true
}

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

variable "vpc_name" {
  description = "The name of the VPC."
  type        = string
  default     = "aviatrix-transit-vpc"
}

variable "vpc_address_space" {
  description = "The address space used for the VPC."
  type        = string
  default     = "10.0.0.0/23"
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
  default     = "us-east-1a"
}

variable "aviatrix_transit_availability_zone_2" {
  description = "The availability zone for HA Aviatrix Transit Gateway"
  type        = string
  default     = "us-east-1b"
}

variable "aviatrix_access_account_name" {
  description = "The name of the access account to be used in the Aviatrix Controller for deployment of Transit Gateways."
  type        = string
}

variable "insane_mode" {
  type        = bool
  description = "Enable insane mode for transit gateway."
  default     = false
}

variable "aviatrix_transit_gateway_name" {
  type        = string
  description = "The name used for the transit gateway resource"
  default     = "aviatrix-transit-gw"
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

variable "firewall_mgmt_security_group_name" {
  description = "The name of the Security Group for Firewall Management."
  type        = string
  default     = "aviatrix-firewall-mgmt-security-group"
}

variable "firewall_allowed_ips" {
  description = "List of allowed User Public Ips to be added as ingress rule for security group."
  type        = list(string)
  default     = []
}

# variable "firewall_image" {
#   type        = string
#   description = "The firewall image to be used to deploy the NGFW's"
#   default     = "Palo Alto Networks VM-Series Next-Generation Firewall Bundle 1"
#   validation {
#     condition     = contains(["Palo Alto Networks VM-Series Next-Generation Firewall Bundle 1", ""], var.firewall_image)
#     error_message = "The firewall_image must be one of values in the condition statement."
#   }
# }

# variable "firewall_image_version" {
#   description = "The firewall image version specific to the NGFW vendor image"
#   type        = string
#   default     = "10.1.4"
# }

# variable "firewall_aws_key_pair_name" {
#   description = "The key pair name to be used for Firewall EC2 Instance Deployments."
#   type        = string
#   default     = "aviatrix-firenet-key"
# }

# variable "firewall_public_key" {
#   description = "The key pair public ssh key to be used for Firewall Instance Deployments."
#   type        = string
#   default     = ""
# }

# variable "firewall_private_key_location" {
#   description = "The location of the private key on the local machine to authenticate to palo firewall to change admin credentials."
#   type        = string
#   default     = ""
# }

# variable "firewalls" {
#   description = "The firewall instance information required for creating firewalls"
#   type = list(object({
#     name = string,
#     size = string
#   }))
#   default = []
# }

# variable "s3_bucket_name" {
#   description = "The name of the S3 Bucket to store Firewall Bootstrap."
#   type        = string
#   default     = ""
# }

# variable "s3_iam_role_name" {
#   description = "The name of the iam role used to access S3 Bucket."
#   type        = string
#   default     = "aviatrix-s3-bootstrap-role"
# }

variable "deploy_palo_alto_firewalls" {
  description = "All of the attributes to deploy Palo Alto Firewalls"
  type = object({
    s3_bucket_name = string,
    s3_iam_role_name = string,
    aws_key_pair_public_key = string,
    aws_firewall_key_pair_name = string,
    firewall_private_key_location = string,
    firewall_password = string,
    store_firewall_password_in_ssm = bool,
    firewalls = list(object({
      name = string
    }))
    firewall_image = string,
    firewall_image_version = string
    firewall_size = string
  })
  default = null
}

locals {
  is_aws_gov                     = length(regexall("gov", var.region)) > 0 ? true : false
  cidrbits                       = tonumber(split("/", var.vpc_address_space)[1])
  transit_gateway_newbits        = var.insane_mode ? 26 - local.cidrbits : 28 - local.cidrbits
  firewall_subnet_newbits        = 28 - local.cidrbits
  combined_cidr_subnets          = cidrsubnets(var.vpc_address_space, local.transit_gateway_newbits, local.transit_gateway_newbits, local.firewall_subnet_newbits, local.firewall_subnet_newbits, local.firewall_subnet_newbits, local.firewall_subnet_newbits)
  transit_gateway_subnet         = local.combined_cidr_subnets[0]
  transit_gateway_ha_subnet      = local.combined_cidr_subnets[1]
  firewall_mgmt_primary_subnet   = local.combined_cidr_subnets[2]
  firewall_mgmt_ha_subnet        = local.combined_cidr_subnets[3]
  firewall_egress_primary_subnet = local.combined_cidr_subnets[4]
  firewall_egress_ha_subnet      = local.combined_cidr_subnets[5]
}
