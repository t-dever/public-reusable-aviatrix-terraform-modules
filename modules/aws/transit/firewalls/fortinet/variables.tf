locals {
  firewall_subnet           = cidrsubnet(var.vnet_address_prefix, local.firewall_newbits, 0)
  firewall_wan_gateway      = cidrhost(local.firewall_subnet, 1)
  fortinet_bootstrap = var.egress_enabled ? templatefile("${path.module}/fortinet_egress_init.tftpl", { wan_gateway = local.firewall_wan_gateway }) : templatefile("${path.module}/fortinet_init.tftpl")  
}
