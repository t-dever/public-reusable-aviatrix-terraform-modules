locals {
  gateway_name         = "${var.resource_prefix}-az-spoke-gw"
  vm1_name             = "${var.resource_prefix}-vm1"
  storage_account_name = replace("${var.resource_prefix}sa", "-", "")
}

resource "azurerm_resource_group" "azure_spoke_resource_group" {
  name     = "${var.resource_prefix}-rg"
  location = var.location
}

resource "azurerm_storage_account" "spoke_storage_account" {
  name                      = local.storage_account_name
  resource_group_name       = azurerm_resource_group.azure_spoke_resource_group.name
  location                  = var.location
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  min_tls_version           = "TLS1_2"
  allow_blob_public_access  = false
  enable_https_traffic_only = true
  network_rules {
    default_action = "Deny"
    bypass         = ["AzureServices"]
    virtual_network_subnet_ids = [
      azurerm_subnet.azure_spoke_gateway_subnet.id,
      azurerm_subnet.azure_virtual_machines_subnet.id
    ]
  }
}

############### START - VIRTUAL NETWORK ###############
resource "azurerm_virtual_network" "azure_spoke_vnet" {
  name                = "${var.resource_prefix}-vnet"
  location            = var.location
  resource_group_name = azurerm_resource_group.azure_spoke_resource_group.name
  address_space       = [var.vnet_address_prefix]
}
resource "azurerm_subnet" "azure_spoke_gateway_subnet" {
  depends_on = [
    azurerm_virtual_network.azure_spoke_vnet
  ]
  name                 = "gateway-subnet"
  virtual_network_name = "${var.resource_prefix}-vnet"
  resource_group_name  = azurerm_resource_group.azure_spoke_resource_group.name
  address_prefixes     = [var.gateway_subnet_address_prefix]
  service_endpoints    = ["Microsoft.Storage"]
}
resource "azurerm_subnet" "azure_virtual_machines_subnet" {
  depends_on = [
    azurerm_virtual_network.azure_spoke_vnet
  ]
  name                 = "virtual-machines"
  virtual_network_name = "${var.resource_prefix}-vnet"
  resource_group_name  = azurerm_resource_group.azure_spoke_resource_group.name
  address_prefixes     = [var.virtual_machines_subnet_address_prefix]
  service_endpoints    = ["Microsoft.Storage"]
}

resource "azurerm_route_table" "virtual_machine_route_table" {
  lifecycle {
    ignore_changes = [route]
  }
  name                          = "virtual-machine-private-rtb"
  location                      = azurerm_resource_group.azure_spoke_resource_group.location
  resource_group_name           = azurerm_resource_group.azure_spoke_resource_group.name
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
  name                    = "${local.gateway_name}-public-ip"
  location                = var.location
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
  gw_name                           = local.gateway_name
  vpc_id                            = "${azurerm_virtual_network.azure_spoke_vnet.name}:${azurerm_virtual_network.azure_spoke_vnet.resource_group_name}"
  vpc_reg                           = var.location
  gw_size                           = "Standard_B1ms"
  subnet                            = azurerm_subnet.azure_spoke_gateway_subnet.address_prefix
  allocate_new_eip                  = false
  eip                               = azurerm_public_ip.azure_gateway_public_ip.ip_address
  azure_eip_name_resource_group     = "${azurerm_public_ip.azure_gateway_public_ip.name}:${azurerm_virtual_network.azure_spoke_vnet.resource_group_name}"
  manage_transit_gateway_attachment = false
  # enable_active_mesh                = true # Removed for Aviatrix Release 6.6
}

# data "azurerm_network_security_group" "gateway_security_group" {
#   depends_on = [
#     aviatrix_spoke_gateway.azure_spoke_gateway
#   ]
#   name                = "av-sg-${local.gateway_name}"
#   resource_group_name = azurerm_resource_group.azure_spoke_resource_group.name
# }

resource "aviatrix_spoke_transit_attachment" "attach_spoke" {
  depends_on = [
    aviatrix_spoke_gateway.azure_spoke_gateway
  ]
  spoke_gw_name   = aviatrix_spoke_gateway.azure_spoke_gateway.gw_name
  transit_gw_name = var.transit_gateway_name
}

# resource "aviatrix_transit_firenet_policy" "spoke_transit_firenet_policy" {
#   depends_on = [
#     aviatrix_spoke_gateway.azure_spoke_gateway,
#     aviatrix_spoke_transit_attachment.attach_spoke
#   ]
#   transit_firenet_gateway_name = var.transit_gateway_name
#   inspected_resource_name      = "SPOKE:${aviatrix_spoke_gateway.azure_spoke_gateway.gw_name}"
# }

data "azurerm_virtual_machine" "gateway_vm_data" {
  depends_on = [
    aviatrix_spoke_gateway.azure_spoke_gateway
  ]
  name                = "av-gw-${local.gateway_name}"
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
  name         = local.vm1_name
  value        = random_password.generate_vm1_secret.result
  key_vault_id = var.key_vault_id
  content_type = "${local.vm1_name}:adminuser"
}

resource "azurerm_network_interface" "virtual_machine1_nic1" {
  name                = "${local.vm1_name}-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.azure_spoke_resource_group.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.azure_virtual_machines_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "virtual_machine1" {
  name                            = local.vm1_name
  resource_group_name             = azurerm_resource_group.azure_spoke_resource_group.name
  location                        = var.location
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
    name                 = "${var.resource_prefix}-osdisk"
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
  location           = var.location
  enabled            = true

  daily_recurrence_time = "1800"
  timezone              = "Central Standard Time"
  notification_settings {
    enabled = false
  }
}
############### STOP - TEST VIRTUAL MACHINE ###############
