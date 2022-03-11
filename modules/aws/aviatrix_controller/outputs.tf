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
  value       = aws_eip.aviatrix_copilot_eip.public_ip
}

output "aviatrix_copilot_private_ip" {
  description = "The Aviatrix CoPilot private IP Address."
  value       = local.copilot_private_ip
}

output "aviatrix_gateway_cidrs" {
  description = "Gateway Cidrs found on Aviatrix Controller Security Groups"
  value       = jsondecode(data.external.get_aviatrix_gateway_cidrs.result.gateway_cidrs)
}