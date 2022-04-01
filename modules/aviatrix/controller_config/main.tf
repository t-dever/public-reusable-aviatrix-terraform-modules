resource "aviatrix_controller_security_group_management_config" "security_group_management" {
  count                            = var.enable_security_group_management ? 1 : 0
  account_name                     = var.aviatrix_access_account_name
  enable_security_group_management = true
}

resource "aviatrix_copilot_association" "copilot_association" {
  count           = length(var.copilot_ip_address) < 0 ? 1 : 0
  copilot_address = var.copilot_ip_address
}

resource "aviatrix_netflow_agent" "netflow_agent" {
  count     = var.enable_netflow_to_copilot && length(var.copilot_ip_address) < 0 ? 1 : 0
  server_ip = var.copilot_ip_address
  port      = var.netflow_port
  version   = 9
}

resource "aviatrix_remote_syslog" "remote_syslog" {
  count    = var.enable_rsyslog_to_copilot && length(var.copilot_ip_address) < 0 ? 1 : 0
  index    = 0
  name     = "copilot"
  server   = var.copilot_ip_address
  port     = var.rsyslog_port
  protocol = var.rsyslog_protocol
}

resource "aviatrix_controller_config" "controller_backup" {
  count                 = length(var.enable_azure_backup.backup_account_name) > 0 ? 1 : 0
  backup_configuration  = true
  backup_cloud_type     = 8
  backup_account_name   = var.enable_azure_backup.backup_account_name
  backup_storage_name   = var.enable_azure_backup.backup_storage_name
  backup_container_name = var.enable_azure_backup.backup_container_name
  backup_region         = var.enable_azure_backup.backup_region
  multiple_backups      = true
}
