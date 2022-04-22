terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.4.0"
    }
    aviatrix = {
      source  = "AviatrixSystems/aviatrix"
      version = "2.21.0-6.6.ga"
    }
  }
}

# provider "aws" {
#   region = var.region
#   default_tags {
#     tags = var.tags
#   }
# }

# provider "aviatrix" {
#   controller_ip = var.controller_public_ip
#   username      = var.controller_username
#   password      = var.controller_password
# }