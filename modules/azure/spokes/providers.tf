terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.89.0"
    }
    aviatrix = {
      source  = "AviatrixSystems/aviatrix"
      version = "2.21.0-6.6.ga"
    }
  }
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}

provider "aviatrix" {
  controller_ip = var.controller_public_ip
  username      = var.controller_username
  password      = var.controller_password
}