resource "panos_management_profile" "allow_health_probes" {
  name          = "HealthCheck"
  https         = true
  permitted_ips = ["168.63.129.16", ]
}

resource "panos_ethernet_interface" "ethernet_1" {
  name                      = "ethernet1/1"
  vsys                      = "vsys1"
  mode                      = "layer3"
  enable_dhcp               = true
  create_dhcp_default_route = false
  comment                   = "Configured for external traffic"
}

resource "panos_ethernet_interface" "ethernet_2" {
  name                      = "ethernet1/2"
  vsys                      = "vsys1"
  mode                      = "layer3"
  enable_dhcp               = true
  create_dhcp_default_route = false
  management_profile        = panos_management_profile.allow_health_probes.name
  comment                   = "Configured for internal traffic"
}

resource "panos_virtual_router" "default_virtual_router" {
  name = "default"
  interfaces = [
    panos_ethernet_interface.ethernet_1.name,
    panos_ethernet_interface.ethernet_2.name
  ]
}

resource "panos_zone" "wan_zone" {
  name = "WAN"
  mode = "layer3"
  interfaces = [
    panos_ethernet_interface.ethernet_1.name,
  ]
}

resource "panos_zone" "lan_zone" {
  name = "LAN"
  mode = "layer3"
  interfaces = [
    panos_ethernet_interface.ethernet_2.name,
  ]
}

resource "panos_security_policy" "allow_all" {
  rule {
    name                  = "allowAll"
    source_zones          = ["any"]
    source_addresses      = ["any"]
    source_users          = ["any"]
    hip_profiles          = ["any"]
    destination_zones     = ["any"]
    destination_addresses = ["any"]
    applications          = ["any"]
    services              = ["application-default"]
    categories            = ["any"]
    action                = "allow"
  }
}

resource "null_resource" "commit_configuration" {
  depends_on = [
    panos_management_profile.allow_health_probes,
    panos_ethernet_interface.ethernet_1,
    panos_ethernet_interface.ethernet_2,
    panos_virtual_router.default_virtual_router,
    panos_zone.wan_zone,
    panos_zone.lan_zone,
    panos_security_policy.allow_all
  ]
  provisioner "local-exec" {
    command = "python3 ${path.module}/commit.py"
    environment = {
      IP_ADDRESS = var.palo_ip_address
      USERNAME   = var.palo_username
      PASSWORD   = var.palo_password
    }
  }
}
