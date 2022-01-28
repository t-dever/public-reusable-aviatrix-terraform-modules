variable "resource_prefix" {
  description = "The prefix to the resource group that will be used for all created resources"
  type        = string
}

variable "user_principal_id" {
  description = "The ID of the user that needs to access the key vault via Azure Portal GUI. This is used to give key vault secrets officer role"
  type        = string
}

# variable "build_agent_ip_address" {
#   description = "The Public IP Address of the build agent to add to the NSG allow rule"
#   type        = string
#   sensitive   = true
#   default     = "1.1.1.1"
# }

# variable "controller_user_public_ip_address" {
#   description = "The public IP address of the user that is logging into the controller"
#   type        = string
#   sensitive   = true
# }

variable "generate_private_ssh_key" {
  description = "Generate a private SSH key and store it in the key vault."
  type        = bool
  default     = false
}

variable "allowed_public_ips" {
  description = "A list of allowed public IP's access to key vault and storage accounts."
  type        = list(string)
  default     = []
  sensitive   = true
}