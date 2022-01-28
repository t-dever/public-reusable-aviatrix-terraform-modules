variable "resource_prefix" {
  description = "The prefix to the resource group that will be used for all created resources"
  type        = string
}

variable "user_principal_id" {
  description = "The ID of the user that needs to access the key vault via Azure Portal GUI. This is used to give key vault secrets officer role"
  type        = string
}

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
