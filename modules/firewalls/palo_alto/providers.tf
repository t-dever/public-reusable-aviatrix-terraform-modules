terraform {
  required_providers {
    panos = {
      source  = "PaloAltoNetworks/panos"
      version = "1.8.3"
    }
  }
}
provider "panos" {
  #checkov:skip=CKV_PAN_1:"Ensure no hard coded PAN-OS credentials exist in provider" REASON: Variables are passed in as sensitive and should be secure.
  hostname = var.palo_ip_address
  username = var.palo_username
  password = var.palo_password
}