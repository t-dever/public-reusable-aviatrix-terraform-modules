resource "azurerm_resource_group" "resource_group" {
  name     = var.resource_group_name
  location = var.location
}

resource "random_password" "generate_controller_secret" {
  length           = 24
  min_upper        = 2
  min_numeric      = 2
  min_special      = 2
  special          = true
  override_special = "_%@"
}

resource "azurerm_key_vault_secret" "aviatrix_admin_secret" {
  count        = var.store_credentials_in_key_vault ? 1 : 0
  name         = "controller-admin-pw"
  value        = random_password.generate_controller_secret.result
  key_vault_id = var.key_vault_id
  content_type = "aviatrix controller admin password username admin"
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
  name         = "controller-public-ip"
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
    private_ip_address            = cidrhost(azurerm_subnet.azure_controller_subnet.address_prefix, 4)
    public_ip_address_id          = azurerm_public_ip.azure_controller_public_ip.id
  }
}

resource "tls_private_key" "generate_private_key" {
  count     = length(var.ssh_public_key) >= 0 ? 0 : 1
  algorithm = "RSA"
  rsa_bits  = 2048
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
  size                            = var.controller_vm_size
  priority                        = var.enable_spot_instances ? "Spot" : null
  eviction_policy                 = var.enable_spot_instances ? "Deallocate" : null
  admin_username                  = "adminUser"
  disable_password_authentication = true
  allow_extension_operations      = false

  admin_ssh_key {
    username   = "adminUser"
    public_key = length(var.ssh_public_key) >= 0 ? var.ssh_public_key : tls_private_key.generate_private_key[0].public_key_openssh
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

resource "null_resource" "initial_config" {
  depends_on = [
    azurerm_linux_virtual_machine.aviatrix_controller_vm
  ]
  triggers = {
    "id" = azurerm_linux_virtual_machine.aviatrix_controller_vm.id
  }
  provisioner "local-exec" {
    command = "python ${path.module}/initial_controller_setup.py"
    environment = {
      AVIATRIX_CONTROLLER_PUBLIC_IP  = azurerm_public_ip.azure_controller_public_ip.ip_address
      AVIATRIX_CONTROLLER_PRIVATE_IP = azurerm_network_interface.azure_controller_nic.private_ip_address
      AVIATRIX_CONTROLLER_PASSWORD   = random_password.generate_controller_secret.result
      ADMIN_EMAIL                    = var.admin_email
      CONTROLLER_VERSION             = var.controller_version
      CUSTOMER_ID                    = var.controller_customer_id
      # ACCESS_ACCOUNT                 = var.aviatrix_azure_access_account_name
      # SUBSCRIPTION_ID                = data.azurerm_client_config.current.subscription_id
      # DIRECTORY_ID                   = data.azurerm_client_config.current.tenant_id
      # CLIENT_ID                      = data.azurerm_client_config.current.client_id
      # CLIENT_SECRET                  = var.azure_application_key
    }
  }
}

# Deploy CoPilot Resources

resource "azurerm_public_ip" "azure_copilot_public_ip" {
  count                   = var.deploy_copilot ? 1 : 0
  name                    = "${var.copilot_name}-public-ip"
  location                = azurerm_resource_group.resource_group.location
  resource_group_name     = azurerm_resource_group.resource_group.name
  sku                     = "Basic"
  allocation_method       = "Static"
  idle_timeout_in_minutes = 30
}

resource "azurerm_network_interface" "azure_copilot_nic" {
  name                = "${var.copilot_name}-nic"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name

  ip_configuration {
    name                          = "${var.copilot_name}-nic-ip"
    subnet_id                     = azurerm_subnet.azure_controller_subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = cidrhost(azurerm_subnet.azure_controller_subnet.address_prefix, 5)
    public_ip_address_id          = azurerm_public_ip.azure_copilot_public_ip[0].id
  }
}

resource "azurerm_linux_virtual_machine" "aviatrix_copilot_vm" {
  name                            = var.copilot_name
  location                        = azurerm_resource_group.resource_group.location
  resource_group_name             = azurerm_resource_group.resource_group.name
  network_interface_ids           = ["${azurerm_network_interface.azure_copilot_nic.id}"]
  computer_name                   = "avx-copilot"
  size                            = var.copilot_vm_size
  priority                        = var.enable_spot_instances ? "Spot" : null
  eviction_policy                 = var.enable_spot_instances ? "Deallocate" : null
  admin_username                  = "adminUser"
  disable_password_authentication = true
  allow_extension_operations      = false

  admin_ssh_key {
    username   = "adminUser"
    public_key = length(var.ssh_public_key) >= 0 ? var.ssh_public_key : tls_private_key.generate_private_key[0].public_key_openssh
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
    name                 = "${var.copilot_name}-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
}

resource "azurerm_dev_test_global_vm_shutdown_schedule" "copilot_shutdown" {
  count              = var.deploy_copilot && var.enable_scheduled_shutdown ? 1 : 0
  virtual_machine_id = azurerm_linux_virtual_machine.aviatrix_copilot_vm.id
  location           = azurerm_resource_group.resource_group.location
  enabled            = true

  daily_recurrence_time = "1800"
  timezone              = "Central Standard Time"
  notification_settings {
    enabled = false
  }
}
