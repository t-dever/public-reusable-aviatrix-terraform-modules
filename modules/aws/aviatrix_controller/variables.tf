variable "region" {
  description = "The region where the resources will be deployed."
  type        = string
  default     = "us-east-1"
}

variable "aws_key_pair_name" {
  description = "The key pair name to be used for EC2 Instance Deployments."
  type        = string
  default     = "aviatrix-controller-key"
}

variable "aws_key_pair_public_key" {
  description = "The key pair public ssh key to be used for EC2 Instance Deployments."
  type        = string
}

variable "vpc_address_space" {
  description = "The address space used for the VPC."
  type        = string
  default     = "10.0.0.0/24"
}

variable "aviatrix_controller_subnet" {
  description = "The aviatrix controller subnet to be created."
  type = object({
    name              = string,
    cidr_block        = string,
    availability_zone = string
  })
  default = {
    name              = "aviatrix-controller",
    cidr_block        = "10.0.0.0/26"
    availability_zone = "us-east-1a"
  }
}

variable "aviatrix_copilot_subnet" {
  description = "The aviatrix copilot subnet to be created."
  type = object({
    name              = string,
    cidr_block        = string,
    availability_zone = string
  })
  default = {
    name              = "aviatrix-copilot",
    cidr_block        = "10.0.0.64/26"
    availability_zone = "us-east-1a"
  }
}

variable "additional_subnets" {
  description = "The subnets to be created."
  type = map(object({
    cidr_block        = string,
    availability_zone = string
  }))
  default = {}
}

variable "vpc_name" {
  description = "The name of the VPC."
  type        = string
  default     = "aviatrix-controller-vpc"
}

variable "arn_partition" {
  description = "The value used in ARN ID."
  type        = string
  default     = "aws" # For Gov use "aws-us-gov"
}

variable "aviatrix_controller_name" {
  description = "Name of controller that will be launched."
  type        = string
  default     = "aviatrix-controller"
}

variable "aviatrix_controller_security_group_name" {
  description = "The name of the security group for the Aviatrix Controller."
  type        = string
  default     = "aviatrix-controller-security-group"
}

variable "allowed_ips" {
  description = "List of allowed ips to be added as ingress rule for security group."
  type        = list(string)
  default     = []
}

variable "aviatrix_controller_instance_size" {
  description = "Aviatrix Controller instance size."
  type        = string
  default     = "t3.large"
}

variable "aviatrix_controller_root_volume_size" {
  description = "Root volume disk size for controller"
  type        = number
  default     = 32
}

variable "aviatrix_controller_root_volume_type" {
  description = "Root volume type for controller"
  type        = string
  default     = "gp2"
}

variable "aviatrix_controller_admin_email" {
  description = "The administrators email address for initial controller provisioning."
  type        = string
}

variable "aviatrix_controller_version" {
  description = "The version used for the controller"
  type        = string
  default     = "UserConnect-6.6.5230"
}

variable "aviatrix_controller_customer_id" {
  description = "The customer id for the aviatrix controller"
  type        = string
  sensitive   = true
}

variable "aviatrix_aws_primary_account_name" {
  description = "The primary account name to be added to the aviatrix access accounts."
  type        = string
  default     = "aviatrix-aws-primary-account"
}

variable "aviatrix_copilot_name" {
  description = "Name of copilot that will be launched."
  type        = string
  default     = "aviatrix-copilot"
}

variable "aviatrix_copilot_instance_size" {
  description = "Aviatrix CoPilot instance size."
  type        = string
  default     = "t3.2xlarge"
}

variable "aviatrix_copilot_root_volume_size" {
  type        = number
  description = "Root volume size for copilot"
  default     = 25

  validation {
    condition     = var.aviatrix_copilot_root_volume_size >= 25
    error_message = "The minimum root volume size is 25G."
  }
}

variable "aviatrix_copilot_root_volume_type" {
  type        = string
  description = "Root volume type for copilot"
  default     = "gp2"
}


variable "aviatrix_copilot_additional_volumes" {
  description = "Additonal volumes to add to CoPilot."
  type = map(object({
    device_name = string,
    volume_id   = string,
  }))
  default = {}
}

variable "tag_prefix" {
  description = "The prefix of tagged resource names."
  type        = string
  default     = "aviatrix"
}

variable "tags" {
  description = "The tags used for resources."
  type        = map(any)
  default     = {}
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "http" "aviatrix_controller_iam_id" {
  url = "https://s3-us-west-2.amazonaws.com/aviatrix-download/AMI_ID/ami_id.json"
  request_headers = {
    "Accept" = "application/json"
  }
}

data "http" "aviatrix_copilot_iam_id" {
  url = "https://aviatrix-download.s3.us-west-2.amazonaws.com/AMI_ID/copilot_ami_id.json"
  request_headers = {
    "Accept" = "application/json"
  }
}

locals {
  controller_images = jsondecode(data.http.aviatrix_controller_iam_id.body).BYOL
  controller_ami_id = local.controller_images[data.aws_region.current.name]
  copilot_images    = jsondecode(data.http.aviatrix_copilot_iam_id.body).Copilot
  copilot_ami_id    = local.copilot_images[data.aws_region.current.name]
}
