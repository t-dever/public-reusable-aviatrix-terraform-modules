resource "fortios_system_interface" "trname" {
  algorithm    = "L4"
  mtu          = 1500
  mtu_override = "disable"
  name         = "port2"
  type         = "physical"
  vdom         = "root"
  mode         = "dhcp"
  description  = "Created by Terraform Provider for FortiOS"
  allowaccess = "HTTPS"
}