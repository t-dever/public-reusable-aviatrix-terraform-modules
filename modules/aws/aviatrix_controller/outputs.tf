output "aviatrix_controller_public_ip" {
  description = "The Aviatrix Controllers public IP Address."
  value       = aws_eip.aviatrix_controller_eip.public_ip
}

output "aviatrix_controller_private_ip" {
  description = "The Aviatrix Controllers private IP Address."
  value       = local.controller_private_ip
}

output "aviatrix_copilot_public_ip" {
  description = "The Aviatrix CoPilot public IP Address."
  value       = var.deploy_aviatrix_copilot ? aws_eip.aviatrix_copilot_eip[0].public_ip : null
}

output "aviatrix_copilot_private_ip" {
  description = "The Aviatrix CoPilot private IP Address."
  value       = local.copilot_private_ip
}

output "aviatrix_gateway_cidrs" {
  description = "Gateway Cidrs found on Aviatrix Controller Security Groups"
  value       = var.deploy_aviatrix_copilot && var.enable_auto_aviatrix_copilot_security_group ? jsondecode(data.external.get_aviatrix_gateway_cidrs[0].result.gateway_cidrs) : null
}

output "aws_app_role_arn" {
  description = "The ARN for the app role created."
  value       = aws_iam_role.aviatrix_role_app.arn
}

output "aws_ec2_role_arn" {
  description = "The ARN for the ec2 role created."
  value       = aws_iam_role.aviatrix_role_ec2.arn
}