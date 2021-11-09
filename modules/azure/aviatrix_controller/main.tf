provider "azurerm" {
  features {}
  skip_provider_registration = true
}

data "azurerm_client_config" "current" {}

locals {
  copilot_name    = "${var.resource_prefix}-copilot-vm"
  controller_name = "${var.resource_prefix}-controller-vm"
}

resource "azurerm_resource_group" "resource_group" {
  name     = "${var.resource_prefix}-rg"
  location = var.location
}

resource "azurerm_storage_account" "storage_account" {
  name                     = replace("${var.resource_prefix}sa", "-", "")
  resource_group_name      = azurerm_resource_group.resource_group.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
  allow_blob_public_access = false
}

resource "azurerm_virtual_network" "azure_controller_vnet" {
  name                = "${var.resource_prefix}-vnet"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  address_space       = [var.vnet_address_prefix]
}

resource "azurerm_subnet" "azure_controller_subnet" {
  depends_on = [
    azurerm_virtual_network.azure_controller_vnet
  ]
  name                 = "aviatrix-controller"
  virtual_network_name = "${var.resource_prefix}-vnet"
  resource_group_name  = azurerm_resource_group.resource_group.name
  address_prefixes     = [var.controller_subnet_address_prefix]
}

resource "azurerm_public_ip" "azure_controller_public_ip" {
  name                    = "${local.controller_name}-public-ip"
  location                = azurerm_resource_group.resource_group.location
  resource_group_name     = azurerm_resource_group.resource_group.name
  sku                     = "Basic"
  allocation_method       = "Static"
  idle_timeout_in_minutes = 30
}

resource "azurerm_public_ip" "azure_copilot_public_ip" {
  name                    = "${local.copilot_name}-public-ip"
  location                = azurerm_resource_group.resource_group.location
  resource_group_name     = azurerm_resource_group.resource_group.name
  sku                     = "Basic"
  allocation_method       = "Static"
  idle_timeout_in_minutes = 30
}
resource "azurerm_network_interface" "azure_controller_nic" {
  name                = "${local.controller_name}-nic"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name

  ip_configuration {
    name                          = "${local.controller_name}-nic-ip"
    subnet_id                     = azurerm_subnet.azure_controller_subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.0.4"
    public_ip_address_id          = azurerm_public_ip.azure_controller_public_ip.id
  }
}

resource "azurerm_network_interface" "azure_copilot_nic" {
  name                = "${local.copilot_name}-nic"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name

  ip_configuration {
    name                          = "${local.copilot_name}-nic-ip"
    subnet_id                     = azurerm_subnet.azure_controller_subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.0.5"
    public_ip_address_id          = azurerm_public_ip.azure_copilot_public_ip.id
  }
}

# # This has to be done in order to see the outputs from the initial_controller_config.py script,
# # otherwise it will block all outputs and you won't know the status of the script.
resource "local_file" "controller_secret" {
  lifecycle {
    ignore_changes = all
  }
  sensitive_content = var.controller_admin_password
  filename          = "./controller_secret.txt"
}
# # This has to be done in order to see the outputs from the initial_controller_config.py script,
# # otherwise it will block all outputs and you won't know the status of the script.
resource "local_file" "controller_customer_id" {
  lifecycle {
    ignore_changes = all
  }
  sensitive_content = var.controller_customer_id
  filename          = "./customer_id.txt"
}

resource "azurerm_linux_virtual_machine" "aviatrix_controller_vm" {
  depends_on = [
    local_file.controller_secret,
    local_file.controller_customer_id
  ]
  name                            = local.controller_name
  location                        = azurerm_resource_group.resource_group.location
  resource_group_name             = azurerm_resource_group.resource_group.name
  network_interface_ids           = ["${azurerm_network_interface.azure_controller_nic.id}"]
  computer_name                   = "avx-controller"
  size                            = "Standard_D1_v2"
  priority                        = "Spot"
  eviction_policy                 = "Deallocate"
  admin_username                  = "adminUser"
  admin_password                  = "Password1234"
  disable_password_authentication = false

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
    name                 = "${local.controller_name}-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
}

resource "null_resource" "initial_config" {
  depends_on = [
    azurerm_linux_virtual_machine.aviatrix_controller_vm
  ]
  provisioner "local-exec" {
    command = "python3 ${path.module}/initial_controller_setup.py"
    environment = {
      AVIATRIX_CONTROLLER_PUBLIC_IP  = azurerm_public_ip.azure_controller_public_ip.ip_address
      AVIATRIX_CONTROLLER_PRIVATE_IP = azurerm_network_interface.azure_controller_nic.private_ip_address
      AVIATRIX_CONTROLLER_PASSWORD   = var.controller_admin_password
      ADMIN_EMAIL                    = var.admin_email
      ACCESS_ACCOUNT                 = var.aviatrix_azure_access_account_name
      SECRET_CREDENTIAL_FILE_PATH    = "./controller_secret.txt"
      CUSTOMER_ID_FILE_PATH          = "./customer_id.txt"
      SUBSCRIPTION_ID                = data.azurerm_client_config.current.subscription_id
      DIRECTORY_ID                   = data.azurerm_client_config.current.tenant_id
      CLIENT_ID                      = data.azurerm_client_config.current.client_id
      CLIENT_SECRET                  = var.azure_application_key
      CONTROLLER_VERSION             = var.controller_version
    }
  }
}

resource "azurerm_linux_virtual_machine" "aviatrix_copilot_vm" {
  name                            = local.copilot_name
  location                        = azurerm_resource_group.resource_group.location
  resource_group_name             = azurerm_resource_group.resource_group.name
  network_interface_ids           = ["${azurerm_network_interface.azure_copilot_nic.id}"]
  computer_name                   = "avx-copilot"
  size                            = "Standard_D1_v2"
  priority                        = "Spot"
  eviction_policy                 = "Deallocate"
  admin_username                  = "adminUser"
  admin_password                  = "Password123!"
  disable_password_authentication = false

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
    name                 = "${local.copilot_name}-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
}

resource "azurerm_network_security_group" "controller_security_group" {
  lifecycle {
    ignore_changes = [ security_rule ]
  }
  name                = "Aviatrix-SG-${azurerm_public_ip.azure_controller_public_ip.ip_address}"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
}

resource "azurerm_network_security_rule" "allow_user_to_controller_nsg" {
  name                        = "AllowUserHttpsInboundToController"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = var.controller_user_public_ip_address
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.resource_group.name
  network_security_group_name = azurerm_network_security_group.controller_security_group.name
}

resource "azurerm_network_security_rule" "allow_build_agent_to_controller_nsg" {
  name                        = "AllowBuildAgentHttpsInboundToController"
  priority                    = 101
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = var.build_agent_ip_address
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.resource_group.name
  network_security_group_name = azurerm_network_security_group.controller_security_group.name
}

resource "azurerm_subnet_network_security_group_association" "azure_controller_nsg_association" {
  depends_on = [
    null_resource.initial_config
  ]
  subnet_id                 = azurerm_subnet.azure_controller_subnet.id
  network_security_group_id = azurerm_network_security_group.controller_security_group.id
}

resource "azurerm_network_watcher_flow_log" "nsg_flow_logs" {
  network_watcher_name = var.network_watcher_name
  resource_group_name  = "NetworkWatcherRG"
  network_security_group_id = azurerm_network_security_group.controller_security_group.id
  storage_account_id        = azurerm_storage_account.storage_account.id
  enabled                   = true
  version                   = 2
  retention_policy {
    enabled = true
    days    = 7
  }

  traffic_analytics {
    enabled               = true
    workspace_id          = var.log_analytics_workspace_id
    workspace_region      = var.log_analytics_location
    workspace_resource_id = var.log_analytics_id
    interval_in_minutes   = 10
  }
}

resource "azurerm_dev_test_global_vm_shutdown_schedule" "copilot_shutdown" {
  virtual_machine_id = azurerm_linux_virtual_machine.aviatrix_copilot_vm.id
  location           = azurerm_resource_group.resource_group.location
  enabled            = true

  daily_recurrence_time = "1800"
  timezone              = "Central Standard Time"
  notification_settings {
    enabled = false
  }
}

resource "azurerm_dev_test_global_vm_shutdown_schedule" "controller_shutdown" {
  virtual_machine_id = azurerm_linux_virtual_machine.aviatrix_controller_vm.id
  location           = azurerm_resource_group.resource_group.location
  enabled            = true

  daily_recurrence_time = "1800"
  timezone              = "Central Standard Time"
  notification_settings {
    enabled = false
  }
}
