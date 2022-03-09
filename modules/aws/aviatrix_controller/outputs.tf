output "aviatrix_controller_public_ip" {
  description = "The Aviatrix Controllers public IP Address."
  value       = aws_eip.aviatrix_controller_eip.public_ip
}

output "aviatrix_copilot_public_ip" {
  description = "The Aviatrix CoPilot public IP Address."
  value       = aws_eip.aviatrix_copilot_eip.public_ip
}
