resource "fortios_system_interface" "port2" {
  algorithm    = "L4"
  alias        = "Test LAN Port"
  vdom         = "root"
  # mtu          = 1500
  # mtu_override = "disable"
  name         = "port2"
  type         = "physical"
  mode         = "dhcp"
  description  = "Created by Terraform Provider for FortiOS"
  # allowaccess  = "HTTPS"
}