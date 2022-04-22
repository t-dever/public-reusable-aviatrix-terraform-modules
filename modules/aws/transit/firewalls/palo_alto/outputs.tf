output "palo_alto_iam_id" {
  description = "The ID of the IAM role for S3 Bucket Access."
  value       = aws_iam_role.aviatrix_s3_bootstrap_role.id
}

output "bootstrap_bucket_name" {
  description = "The name of the bootstrap bucket."
  value       = local.s3_bucket_name
}

output "firewall_admin_username" {
  description = "The firewall admin username added to the firewall."
  value       = "admin"
}

output "firewall_password" {
  description = "The value of the randomly generated secret."
  value       = length(var.firewall_password) > 0 ? var.firewall_password : random_password.aviatrix_firewall_admin_password[0].result
  sensitive   = true
}

output "firewall_management_interface_ids" {
  description = "List of the firewall management network interface IDs"
  value       = aviatrix_firewall_instance.firewall_instance[*].management_interface
}
