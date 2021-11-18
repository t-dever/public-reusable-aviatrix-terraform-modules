terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.80.0"
    }
    aviatrix = {
      source = "AviatrixSystems/aviatrix"
      version = "2.20.1"
    }
  }
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}

provider "aviatrix" {
  controller_ip = var.controller_public_ip
  password      = var.controller_admin_password
  username      = "admin"
}