resource "fortios_system_interface" "trname" {
  algorithm    = "L4"
  defaultgw    = "enable"
  distance     = 5
  ip           = "0.0.0.0 0.0.0.0"
  mtu          = 1500
  mtu_override = "disable"
  name         = "port2"
  type         = "physical"
  vdom         = "root"
  mode         = "dhcp"
  snmp_index   = 3
  description  = "Created by Terraform Provider for FortiOS"
  ipv6 {
    nd_mode = "basic"
  }
}