terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.89.0"
    }
    aviatrix = {
      source  = "AviatrixSystems/aviatrix"
      # version = ">=2.20.3"
      version = ">=2.21.0-6.6.ga"
    }
  }
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}

provider "aviatrix" {}