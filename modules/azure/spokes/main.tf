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

resource "azurerm_subnet" "azure_spoke_gateway_subnet" {
  depends_on = [
    azurerm_virtual_network.azure_spoke_vnet
  ]
  name                 = "gateway-subnet"
  virtual_network_name = azurerm_virtual_network.azure_spoke_vnet.name
  resource_group_name  = azurerm_resource_group.azure_spoke_resource_group.name
  address_prefixes     = [var.gateway_subnet_address_prefix]
}

resource "azurerm_subnet" "azure_virtual_machines_subnet" {
  depends_on = [
    azurerm_virtual_network.azure_spoke_vnet
  ]
  name                 = "virtual-machines"
  virtual_network_name = azurerm_virtual_network.azure_spoke_vnet.name
  resource_group_name  = azurerm_resource_group.azure_spoke_resource_group.name
  address_prefixes     = [var.virtual_machines_subnet_address_prefix]
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
  subnet_id      = azurerm_subnet.azure_virtual_machines_subnet.id
  route_table_id = azurerm_route_table.virtual_machine_route_table.id
}

############### STOP - VIRTUAL NETWORK ###############

############### START - SPOKE GATEWAY ###############
resource "azurerm_public_ip" "azure_gateway_public_ip" {
  lifecycle {
    ignore_changes = [tags]
  }
  name                    = "${var.spoke_gateway_name}-public-ip"
  location                = azurerm_resource_group.azure_spoke_resource_group.location
  resource_group_name     = azurerm_resource_group.azure_spoke_resource_group.name
  allocation_method       = "Static"
  idle_timeout_in_minutes = 4
  sku                     = "Standard"
}

resource "aviatrix_spoke_gateway" "azure_spoke_gateway" {
  depends_on = [
    azurerm_public_ip.azure_gateway_public_ip
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
  subnet                            = azurerm_subnet.azure_spoke_gateway_subnet.address_prefix
  allocate_new_eip                  = false
  eip                               = azurerm_public_ip.azure_gateway_public_ip.ip_address
  azure_eip_name_resource_group     = "${azurerm_public_ip.azure_gateway_public_ip.name}:${azurerm_virtual_network.azure_spoke_vnet.resource_group_name}"
  manage_transit_gateway_attachment = false
}

resource "aviatrix_spoke_transit_attachment" "attach_spoke" {
  depends_on = [
    aviatrix_spoke_gateway.azure_spoke_gateway
  ]
  spoke_gw_name   = aviatrix_spoke_gateway.azure_spoke_gateway.gw_name
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
  attachment_name      = aviatrix_spoke_gateway.azure_spoke_gateway.gw_name
}

resource "aviatrix_transit_firenet_policy" "spoke_transit_firenet_policy" {
  count = var.firenet_inspection ? 1 : 0
  depends_on = [
    aviatrix_spoke_gateway.azure_spoke_gateway,
    aviatrix_spoke_transit_attachment.attach_spoke
  ]
  transit_firenet_gateway_name = var.transit_gateway_name
  inspected_resource_name      = "SPOKE:${aviatrix_spoke_gateway.azure_spoke_gateway.gw_name}"
}

data "azurerm_virtual_machine" "gateway_vm_data" {
  depends_on = [
    aviatrix_spoke_gateway.azure_spoke_gateway
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
    subnet_id                     = azurerm_subnet.azure_virtual_machines_subnet.id
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
