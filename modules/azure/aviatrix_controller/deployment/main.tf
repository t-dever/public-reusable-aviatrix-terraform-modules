resource "azurerm_resource_group" "resource_group" {
  name     = var.resource_group_name
  location = var.location
}

resource "random_password" "generate_aviatrix_controller_admin_secret" {
  count            = var.aviatrix_controller_password == "" ? 1 : 0
  length           = 24
  min_upper        = 2
  min_numeric      = 2
  min_special      = 2
  special          = true
  override_special = "_%@"
}

resource "random_password" "generate_aviatrix_controller_virtual_machine_admin_secret" {
  count            = var.aviatrix_controller_virtual_machine_admin_password == "" && var.aviatrix_controller_public_ssh_key == "" ? 1 : 0
  length           = 24
  min_upper        = 2
  min_numeric      = 2
  min_special      = 2
  special          = true
  override_special = "_%@"
}

resource "random_password" "generate_aviatrix_copilot_virtual_machine_admin_secret" {
  count            = var.aviatrix_copilot_virtual_machine_admin_password == "" && var.aviatrix_copilot_public_ssh_key == "" ? 1 : 0
  length           = 24
  min_upper        = 2
  min_numeric      = 2
  min_special      = 2
  special          = true
  override_special = "_%@"
}

resource "azurerm_key_vault_secret" "aviatrix_controller_admin_secret" {
  count        = var.store_credentials_in_key_vault ? 1 : 0
  name         = "${var.aviatrix_controller_name}-admin-pw"
  value        = var.aviatrix_controller_password == "" ? random_password.generate_aviatrix_controller_admin_secret[0].result : var.aviatrix_controller_password
  key_vault_id = var.key_vault_id
  content_type = "aviatrix controller admin password username admin"
}

resource "azurerm_key_vault_secret" "aviatrix_controller_virtual_machine_secret" {
  count        = var.store_credentials_in_key_vault && var.aviatrix_controller_public_ssh_key == "" ? 1 : 0
  name         = "${var.aviatrix_controller_name}-virtual-machine-admin-pw"
  value        = var.aviatrix_controller_virtual_machine_admin_password == "" ? random_password.generate_aviatrix_controller_virtual_machine_admin_secret[0].result : var.aviatrix_controller_virtual_machine_admin_password
  key_vault_id = var.key_vault_id
  content_type = "aviatrix virtual machine admin password for username ${var.aviatrix_controller_virtual_machine_admin_username}"
}

resource "azurerm_key_vault_secret" "aviatrix_copilot_virtual_machine_secret" {
  count        = var.store_credentials_in_key_vault && var.aviatrix_copilot_public_ssh_key == "" ? 1 : 0
  name         = "${var.aviatrix_copilot_name}-virtual-machine-admin-pw"
  value        = var.aviatrix_copilot_virtual_machine_admin_password == "" ? random_password.generate_aviatrix_copilot_virtual_machine_admin_secret[0].result : var.aviatrix_copilot_virtual_machine_admin_password
  key_vault_id = var.key_vault_id
  content_type = "aviatrix virtual machine admin password username ${var.aviatrix_copilot_virtual_machine_admin_username}"
}

resource "azurerm_virtual_network" "azure_controller_vnet" {
  name                = var.vnet_name
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  address_space       = [var.vnet_address_prefix]
}

resource "azurerm_subnet" "azure_controller_subnet" {
  depends_on = [
    azurerm_virtual_network.azure_controller_vnet
  ]
  name                 = "aviatrix-controller"
  virtual_network_name = azurerm_virtual_network.azure_controller_vnet.name
  resource_group_name  = azurerm_resource_group.resource_group.name
  address_prefixes     = [var.controller_subnet_address_prefix]
}

resource "azurerm_network_security_group" "aviatrix_controller_security_group" {
  name                = var.aviatrix_controller_security_group_name
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
}

resource "azurerm_network_security_rule" "allow_inbound_public_ips_to_controller_nsg" {
  count                       = length(var.allowed_ips) > 0 ? 1 : 0
  name                        = "AllowPublicIpsHttpsInboundToController"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefixes     = var.allowed_ips
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.resource_group.name
  network_security_group_name = azurerm_network_security_group.aviatrix_controller_security_group.name
}

resource "azurerm_network_security_rule" "allow_controller_inbound_to_copilot" {
  count                       = var.aviatrix_deploy_copilot ? 1 : 0
  name                        = "AllowControllerInboundToCopilot"
  priority                    = 101
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = azurerm_linux_virtual_machine.aviatrix_controller_vm.public_ip_address
  destination_address_prefix  = azurerm_linux_virtual_machine.aviatrix_copilot_vm[0].private_ip_address
  resource_group_name         = azurerm_resource_group.resource_group.name
  network_security_group_name = azurerm_network_security_group.aviatrix_controller_security_group.name
}

resource "azurerm_network_security_rule" "allow_copilot_inbound_to_controller" {
  count                       = var.aviatrix_deploy_copilot ? 1 : 0
  name                        = "AllowCoPilotInboundToController"
  priority                    = 102
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = azurerm_linux_virtual_machine.aviatrix_copilot_vm[0].public_ip_address
  destination_address_prefix  = azurerm_linux_virtual_machine.aviatrix_controller_vm.private_ip_address
  resource_group_name         = azurerm_resource_group.resource_group.name
  network_security_group_name = azurerm_network_security_group.aviatrix_controller_security_group.name
}

# resource "azurerm_network_security_rule" "allow_netflow_inbound_to_copilot" {
#   #checkov:skip=CKV_AZURE_77:Allow all internet UDP to copilot. May restrict this further in later updates.
#   depends_on = [
#     data.azurerm_network_security_group.controller_security_group,
#   ]
#   count                       = var.copilot_private_ip != "" ? 1 : 0
#   name                        = "AllowNetflowInboundToCoPilot"
#   priority                    = 103
#   direction                   = "Inbound"
#   access                      = "Allow"
#   protocol                    = "Udp"
#   source_port_range           = "*"
#   destination_port_ranges     = [var.netflow_port, var.rsyslog_port]
#   source_address_prefix       = "*"
#   destination_address_prefix  = var.copilot_private_ip
#   resource_group_name         = var.resource_group_name
#   network_security_group_name = data.azurerm_network_security_group.controller_security_group.name
# }

resource "azurerm_subnet_network_security_group_association" "azure_controller_nsg_association" {
  subnet_id                 = azurerm_subnet.azure_controller_subnet.id
  network_security_group_id = azurerm_network_security_group.aviatrix_controller_security_group.id
}

resource "azurerm_public_ip" "azure_controller_public_ip" {
  name                    = "${var.aviatrix_controller_name}-public-ip"
  location                = azurerm_resource_group.resource_group.location
  resource_group_name     = azurerm_resource_group.resource_group.name
  sku                     = "Basic"
  allocation_method       = "Static"
  idle_timeout_in_minutes = 30
}

resource "azurerm_key_vault_secret" "aviatrix_controller_public_ip_secret" {
  count        = var.store_credentials_in_key_vault ? 1 : 0
  name         = "${var.aviatrix_controller_name}-public-ip"
  value        = azurerm_public_ip.azure_controller_public_ip.ip_address
  key_vault_id = var.key_vault_id
  content_type = "aviatrix controller public ip address"
}

resource "azurerm_network_interface" "azure_controller_nic" {
  name                = "${var.aviatrix_controller_name}-nic"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name

  ip_configuration {
    name                          = "${var.aviatrix_controller_name}-nic-ip"
    subnet_id                     = azurerm_subnet.azure_controller_subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = local.controller_private_ip
    public_ip_address_id          = azurerm_public_ip.azure_controller_public_ip.id
  }
}

resource "azurerm_linux_virtual_machine" "aviatrix_controller_vm" {
  lifecycle {
    ignore_changes = [tags]
  }
  name                            = var.aviatrix_controller_name
  location                        = azurerm_resource_group.resource_group.location
  resource_group_name             = azurerm_resource_group.resource_group.name
  network_interface_ids           = ["${azurerm_network_interface.azure_controller_nic.id}"]
  computer_name                   = "avx-controller"
  size                            = var.aviatrix_controller_instance_size
  disable_password_authentication = var.aviatrix_controller_public_ssh_key == "" ? false : true
  admin_username                  = var.aviatrix_controller_virtual_machine_admin_username
  admin_password                  = length(var.aviatrix_controller_public_ssh_key) > 0 ? null : var.aviatrix_controller_virtual_machine_admin_password == "" ? random_password.generate_aviatrix_controller_virtual_machine_admin_secret[0].result : var.aviatrix_controller_virtual_machine_admin_password
  priority                        = var.enable_spot_instances ? "Spot" : null
  eviction_policy                 = var.enable_spot_instances ? "Deallocate" : null
  allow_extension_operations      = false

  dynamic "admin_ssh_key" {
    for_each = var.aviatrix_controller_public_ssh_key == "" ? [] : [true]
    content {
      public_key = var.aviatrix_controller_public_ssh_key
      username   = var.aviatrix_controller_virtual_machine_admin_username
    }
  }

  tags = {
    "deploymentTime" : timestamp()
  }

  source_image_reference {
    publisher = "aviatrix-systems"
    offer     = "aviatrix-bundle-payg"
    sku       = "aviatrix-enterprise-bundle-byol"
    version   = "latest"
  }

  plan {
    name      = "aviatrix-enterprise-bundle-byol"
    publisher = "aviatrix-systems"
    product   = "aviatrix-bundle-payg"
  }

  os_disk {
    name                 = "${var.aviatrix_controller_name}-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
}

resource "azurerm_dev_test_global_vm_shutdown_schedule" "controller_shutdown" {
  count              = var.enable_scheduled_shutdown ? 1 : 0
  virtual_machine_id = azurerm_linux_virtual_machine.aviatrix_controller_vm.id
  location           = azurerm_resource_group.resource_group.location
  enabled            = true

  daily_recurrence_time = "1800"
  timezone              = "Central Standard Time"
  notification_settings {
    enabled = false
  }
}

module "aviatrix_controller_initialize" {
  depends_on = [
    azurerm_linux_virtual_machine.aviatrix_controller_vm
  ]
  source                          = "git::https://github.com/t-dever/public-reusable-aviatrix-terraform-modules//modules/aviatrix/controller_initialize?ref=main"
  aviatrix_controller_public_ip   = azurerm_public_ip.azure_controller_public_ip.ip_address
  aviatrix_controller_private_ip  = azurerm_network_interface.azure_controller_nic.private_ip_address
  aviatrix_controller_password    = var.aviatrix_controller_password == "" ? random_password.generate_aviatrix_controller_admin_secret[0].result : var.aviatrix_controller_password
  aviatrix_controller_admin_email = var.aviatrix_controller_admin_email
  aviatrix_controller_version     = var.aviatrix_controller_version
  aviatrix_controller_customer_id = var.aviatrix_controller_customer_id
}

# # Deploy CoPilot Resources

resource "azurerm_public_ip" "azure_copilot_public_ip" {
  count                   = var.aviatrix_deploy_copilot ? 1 : 0
  name                    = "${var.aviatrix_copilot_name}-public-ip"
  location                = azurerm_resource_group.resource_group.location
  resource_group_name     = azurerm_resource_group.resource_group.name
  sku                     = "Basic"
  allocation_method       = "Static"
  idle_timeout_in_minutes = 30
}

resource "azurerm_network_interface" "azure_copilot_nic" {
  count               = var.aviatrix_deploy_copilot ? 1 : 0
  name                = "${var.aviatrix_copilot_name}-nic"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name

  ip_configuration {
    name                          = "${var.aviatrix_copilot_name}-nic-ip"
    subnet_id                     = azurerm_subnet.azure_controller_subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = local.copilot_private_ip
    public_ip_address_id          = azurerm_public_ip.azure_copilot_public_ip[0].id
  }
}

resource "azurerm_linux_virtual_machine" "aviatrix_copilot_vm" {
  count                           = var.aviatrix_deploy_copilot ? 1 : 0
  name                            = var.aviatrix_copilot_name
  location                        = azurerm_resource_group.resource_group.location
  resource_group_name             = azurerm_resource_group.resource_group.name
  network_interface_ids           = ["${azurerm_network_interface.azure_copilot_nic[0].id}"]
  computer_name                   = "avx-copilot"
  size                            = var.aviatrix_copilot_instance_size
  priority                        = var.enable_spot_instances ? "Spot" : null
  eviction_policy                 = var.enable_spot_instances ? "Deallocate" : null
  disable_password_authentication = var.aviatrix_copilot_public_ssh_key == "" ? false : true
  admin_username                  = var.aviatrix_copilot_virtual_machine_admin_username
  admin_password                  = length(var.aviatrix_copilot_public_ssh_key) > 0 ? null : var.aviatrix_copilot_virtual_machine_admin_password == "" ? random_password.generate_aviatrix_copilot_virtual_machine_admin_secret[0].result : var.aviatrix_copilot_virtual_machine_admin_password
  allow_extension_operations      = false


  dynamic "admin_ssh_key" {
    for_each = var.aviatrix_copilot_public_ssh_key == "" ? [] : [true]
    content {
      public_key = var.aviatrix_copilot_public_ssh_key
      username   = var.aviatrix_copilot_virtual_machine_admin_username
    }
  }

  source_image_reference {
    publisher = "aviatrix-systems"
    offer     = "aviatrix-copilot"
    sku       = "avx-cplt-byol-01"
    version   = "latest"
  }

  plan {
    name      = "avx-cplt-byol-01"
    publisher = "aviatrix-systems"
    product   = "aviatrix-copilot"
  }

  os_disk {
    name                 = "${var.aviatrix_copilot_name}-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
}

resource "azurerm_dev_test_global_vm_shutdown_schedule" "copilot_shutdown" {
  count              = var.aviatrix_deploy_copilot && var.enable_scheduled_shutdown ? 1 : 0
  virtual_machine_id = azurerm_linux_virtual_machine.aviatrix_copilot_vm[0].id
  location           = azurerm_resource_group.resource_group.location
  enabled            = true

  daily_recurrence_time = "1800"
  timezone              = "Central Standard Time"
  notification_settings {
    enabled = false
  }
}
