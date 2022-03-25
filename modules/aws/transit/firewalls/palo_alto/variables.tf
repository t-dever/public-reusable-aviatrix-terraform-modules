variable "s3_bucket_name" {
  description = "The name of the S3 Bucket to store Firewall Bootstrap."
  type        = string
  default     = ""
}

variable "s3_iam_role_name" {
  description = "The name of the iam role used to access S3 Bucket."
  type        = string
  default     = "aviatrix-s3-bootstrap-role"
}

variable "aws_key_pair_public_key" {
  description = "The key pair public ssh key to be used for EC2 Instance Deployments."
  type        = string
}

variable "firewall_admin_username" {
  description = "The default firewall admin name."
  type        = string
  default     = "admin"
}

variable "firewall_password" {
  description = "Password used for the admin user of the firewall. If not provided then password will be autogenerated and stored in AWS Systems Manager Parameter Store."
  type        = string
  default     = ""
}

variable "store_firewall_password_in_ssm" {
  description = "Gives the option to store the firewall password in AWS Systems Manager Parameter Store to access."
  type        = bool
  default     = true
}

locals {
  s3_bucket_name = length(var.s3_bucket_name) > 0 ? var.s3_bucket_name : "aviatrix-s3-bucket-${random_id.s3_bucket_random_id[0].hex}"
}