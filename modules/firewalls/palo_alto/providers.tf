terraform {
  required_providers {
    panos = {
      source  = "PaloAltoNetworks/panos"
      version = "1.8.3"
    }
  }
}
provider "panos" {
  hostname = var.palo_ip_address
  username = var.palo_username
  password = var.palo_password
}