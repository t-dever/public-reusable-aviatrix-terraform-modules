output "aviatrix_azure_account" {
  description = "The name of the account added."
  value = var.azure_account_name
}

output "user_public_ip_address" {
  value = var.controller_user_public_ip_address
  description = "The ip address of the user accessing the stuff."
}