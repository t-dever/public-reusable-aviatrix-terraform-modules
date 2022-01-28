terraform {
  required_providers {
    fortios = {
      source  = "fortinetdev/fortios"
      version = "1.13.2"
    }
  }
}

provider "fortios" {
  hostname = var.firewall_ip
  token    = var.firewall_api_key
  insecure = true
}
