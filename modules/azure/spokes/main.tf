resource "azurerm_resource_group" "azure_spoke_resource_group" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_storage_account" "spoke_storage_account" {
  name                      = var.storage_account_name
  resource_group_name       = azurerm_resource_group.azure_spoke_resource_group.name
  location                  = azurerm_resource_group.azure_spoke_resource_group.location
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  min_tls_version           = "TLS1_2"
  allow_blob_public_access  = false
  enable_https_traffic_only = true
}

############### START - VIRTUAL NETWORK ###############
resource "azurerm_virtual_network" "azure_spoke_vnet" {
  name                = var.vnet_name
  location            = azurerm_resource_group.azure_spoke_resource_group.location
  resource_group_name = azurerm_resource_group.azure_spoke_resource_group.name
  address_space       = [var.vnet_address_prefix]
}

resource "azurerm_subnet" "spoke_gw_subnet" {
  name                 = "spoke-gateway-mgmt-subnet"
  virtual_network_name = azurerm_virtual_network.azure_spoke_vnet.name
  resource_group_name  = azurerm_resource_group.azure_spoke_resource_group.name
  address_prefixes     = [local.spoke_gateway_subnet]
}

resource "azurerm_subnet" "spoke_gw_ha_subnet" {
  count                = var.spoke_gateway_ha && var.insane_mode ? 0 : var.spoke_gateway_ha ? 1 : 0
  name                 = "spoke-gateway-ha-mgmt-subnet"
  virtual_network_name = azurerm_virtual_network.azure_spoke_vnet.name
  resource_group_name  = azurerm_resource_group.azure_spoke_resource_group.name
  address_prefixes     = [local.spoke_gateway_ha_subnet]
}

resource "azurerm_subnet" "virtual_machines_subnet" {
  name                 = "virtual-machines"
  virtual_network_name = azurerm_virtual_network.azure_spoke_vnet.name
  resource_group_name  = azurerm_resource_group.azure_spoke_resource_group.name
  address_prefixes     = [local.virtual_machine_subnet]
}

resource "azurerm_route_table" "virtual_machine_route_table" {
  lifecycle {
    ignore_changes = [route]
  }
  name                = "virtual-machine-private-rtb"
  location            = azurerm_resource_group.azure_spoke_resource_group.location
  resource_group_name = azurerm_resource_group.azure_spoke_resource_group.name
  route {
    name           = "default"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "None"
  }
}

resource "azurerm_subnet_route_table_association" "virtual_machine_rtb_association" {
  subnet_id      = azurerm_subnet.virtual_machines_subnet.id
  route_table_id = azurerm_route_table.virtual_machine_route_table.id
}

############### STOP - VIRTUAL NETWORK ###############

############### START - SPOKE GATEWAY ###############
resource "azurerm_public_ip" "spoke_gw_public_ip" {
  lifecycle {
    ignore_changes = [tags]
  }
  name                    = "${var.spoke_gateway_name}-public-ip"
  location                = azurerm_resource_group.azure_spoke_resource_group.location
  resource_group_name     = azurerm_resource_group.azure_spoke_resource_group.name
  allocation_method       = "Static"
  sku                     = "Standard"
  idle_timeout_in_minutes = 4
}

resource "azurerm_public_ip" "spoke_gw_ha_public_ip" {
  lifecycle {
    ignore_changes = [tags]
  }
  count                   = var.spoke_gateway_ha ? 1 : 0
  name                    = "${var.spoke_gateway_name}-ha-public-ip"
  location                = azurerm_resource_group.azure_spoke_resource_group.location
  resource_group_name     = azurerm_resource_group.azure_spoke_resource_group.name
  allocation_method       = "Static"
  sku                     = "Standard"
  idle_timeout_in_minutes = 4
}

resource "aviatrix_spoke_gateway" "spoke_gateway" {
  depends_on = [
    azurerm_public_ip.spoke_gw_public_ip,
    azurerm_public_ip.spoke_gw_ha_public_ip
  ]
  lifecycle {
    ignore_changes = [tags]
  }
  cloud_type                        = 8
  account_name                      = var.aviatrix_azure_account
  gw_name                           = var.spoke_gateway_name
  vpc_id                            = "${azurerm_virtual_network.azure_spoke_vnet.name}:${azurerm_virtual_network.azure_spoke_vnet.resource_group_name}"
  vpc_reg                           = var.location
  gw_size                           = var.spoke_gw_size
  subnet                            = azurerm_subnet.spoke_gw_subnet.address_prefix
  allocate_new_eip                  = false
  eip                               = azurerm_public_ip.spoke_gw_public_ip.ip_address
  azure_eip_name_resource_group     = "${azurerm_public_ip.spoke_gw_public_ip.name}:${azurerm_virtual_network.azure_spoke_vnet.resource_group_name}"
  zone                             = "az-1"
  ha_subnet                        = var.spoke_gateway_ha && var.insane_mode ? local.spoke_gateway_ha_subnet : var.spoke_gateway_ha ? azurerm_subnet.spoke_gw_ha_subnet[0].address_prefixes[0] : null
  ha_zone                          = var.spoke_gateway_ha ? "az-2" : null
  ha_gw_size                       = var.spoke_gateway_ha ? var.spoke_gw_size : null
  ha_eip                           = var.spoke_gateway_ha ? azurerm_public_ip.spoke_gw_ha_public_ip[0].ip_address : null
  ha_azure_eip_name_resource_group = var.spoke_gateway_ha ? "${azurerm_public_ip.spoke_gw_ha_public_ip[0].name}:${azurerm_virtual_network.azure_spoke_vnet.resource_group_name}" : null
  insane_mode                      = var.insane_mode ? true : false
  insane_mode_az                   = var.insane_mode ? "az-1" : null
  ha_insane_mode_az                = var.insane_mode && var.spoke_gateway_ha ? "az-2" : null
  manage_transit_gateway_attachment = false
  enable_vpc_dns_server            = false
}

resource "aviatrix_spoke_transit_attachment" "attach_spoke" {
  spoke_gw_name   = aviatrix_spoke_gateway.spoke_gateway.gw_name
  transit_gw_name = var.transit_gateway_name
}

resource "aviatrix_segmentation_security_domain" "spoke_segmentation_security_domain" {
  domain_name = var.segmentation_domain_name
}

resource "aviatrix_segmentation_security_domain_association" "segmentation_security_domain_association" {
  depends_on = [
    aviatrix_spoke_transit_attachment.attach_spoke,
    aviatrix_segmentation_security_domain.spoke_segmentation_security_domain
  ]
  transit_gateway_name = var.transit_gateway_name
  security_domain_name = var.segmentation_domain_name
  attachment_name      = aviatrix_spoke_gateway.spoke_gateway.gw_name
}

resource "aviatrix_transit_firenet_policy" "spoke_transit_firenet_policy" {
  count = var.firenet_inspection ? 1 : 0
  depends_on = [
    aviatrix_spoke_gateway.spoke_gateway,
    aviatrix_spoke_transit_attachment.attach_spoke
  ]
  transit_firenet_gateway_name = var.transit_gateway_name
  inspected_resource_name      = "SPOKE:${aviatrix_spoke_gateway.spoke_gateway.gw_name}"
}

data "azurerm_virtual_machine" "gateway_vm_data" {
  depends_on = [
    aviatrix_spoke_gateway.spoke_gateway
  ]
  name                = "av-gw-${var.spoke_gateway_name}"
  resource_group_name = azurerm_resource_group.azure_spoke_resource_group.name
}

resource "azurerm_dev_test_global_vm_shutdown_schedule" "gateway_shutdown" {
  virtual_machine_id = data.azurerm_virtual_machine.gateway_vm_data.id
  location           = var.location
  enabled            = true

  daily_recurrence_time = "1800"
  timezone              = "Central Standard Time"
  notification_settings {
    enabled = false
  }
}
############### STOP - SPOKE GATEWAY ###############

############### START - TEST VIRTUAL MACHINE ###############
resource "random_password" "generate_vm1_secret" {
  length           = 16
  special          = true
  override_special = "_%@"
  min_upper        = 1
  min_lower        = 1
  min_numeric      = 1
  min_special      = 1
}

resource "azurerm_key_vault_secret" "vm1_secret" {
  name         = var.test_vm_name
  value        = random_password.generate_vm1_secret.result
  key_vault_id = var.key_vault_id
  content_type = "${var.test_vm_name}:adminuser"
}

resource "azurerm_network_interface" "virtual_machine1_nic1" {
  name                = "${var.test_vm_name}-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.azure_spoke_resource_group.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.virtual_machines_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "virtual_machine1" {
  name                            = var.test_vm_name
  resource_group_name             = azurerm_resource_group.azure_spoke_resource_group.name
  location                        = azurerm_resource_group.azure_spoke_resource_group.location
  size                            = "Standard_DS1_v2"
  admin_username                  = "adminuser"
  admin_password                  = azurerm_key_vault_secret.vm1_secret.value
  disable_password_authentication = false
  allow_extension_operations      = false
  network_interface_ids = [
    azurerm_network_interface.virtual_machine1_nic1.id
  ]
  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.spoke_storage_account.primary_blob_endpoint
  }
  os_disk {
    name                 = "${var.test_vm_name}-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

resource "azurerm_dev_test_global_vm_shutdown_schedule" "vm_shutdown" {
  virtual_machine_id = azurerm_linux_virtual_machine.virtual_machine1.id
  location           = azurerm_resource_group.azure_spoke_resource_group.location
  enabled            = true

  daily_recurrence_time = "1800"
  timezone              = "Central Standard Time"
  notification_settings {
    enabled = false
  }
}
############### STOP - TEST VIRTUAL MACHINE ###############
