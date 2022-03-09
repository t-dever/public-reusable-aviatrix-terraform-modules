resource "null_resource" "initial_config" {
  provisioner "local-exec" {
    command = "python3 ${path.module}/initial_controller_setup.py"
    environment = {
      AVIATRIX_CONTROLLER_PUBLIC_IP  = var.aviatrix_controller_public_ip
      AVIATRIX_CONTROLLER_PRIVATE_IP = var.aviatrix_controller_private_ip
      AVIATRIX_CONTROLLER_PASSWORD   = var.aviatrix_controller_password
      ADMIN_EMAIL                    = var.aviatrix_controller_admin_email
      CONTROLLER_VERSION             = var.aviatrix_controller_version
      CUSTOMER_ID                    = var.aviatrix_controller_customer_id
      AWS_PRIMARY_ACCOUNT_NAME       = var.aviatrix_aws_primary_account_name
      AWS_PRIMARY_ACCOUNT_NUMBER     = var.aviatrix_aws_primary_account_number
    }
  }
}