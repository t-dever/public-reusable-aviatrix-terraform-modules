resource "null_resource" "initial_config" {
  provisioner "local-exec" {
    command = "python3 ${path.module}/initial_controller_setup.py"
    environment = {
      AVIATRIX_CONTROLLER_PUBLIC_IP         = var.aviatrix_controller_public_ip
      AVIATRIX_CONTROLLER_PRIVATE_IP        = var.aviatrix_controller_private_ip
      AVIATRIX_CONTROLLER_PASSWORD          = var.aviatrix_controller_password
      ADMIN_EMAIL                           = var.aviatrix_controller_admin_email
      CONTROLLER_VERSION                    = var.aviatrix_controller_version
      CUSTOMER_ID                           = var.aviatrix_controller_customer_id
      AZURE_PRIMARY_ACCOUNT_NAME            = var.aviatrix_azure_primary_account_name
      AZURE_PRIMARY_ACCOUNT_SUBSCRIPTION_ID = var.aviatrix_azure_primary_account_subscription_id
      AZURE_PRIMARY_ACCOUNT_TENANT_ID       = var.aviatrix_azure_primary_account_tenant_id
      AZURE_PRIMARY_ACCOUNT_CLIENT_ID       = var.aviatrix_azure_primary_account_client_id
      AZURE_PRIMARY_ACCOUNT_CLIENT_SECRET   = var.aviatrix_azure_primary_account_client_secret
      AWS_PRIMARY_ACCOUNT_NAME              = var.aviatrix_aws_primary_account_name
      AWS_PRIMARY_ACCOUNT_NUMBER            = var.aviatrix_aws_primary_account_number
      AWS_ROLE_APP_ARN                      = var.aviatrix_aws_role_app_arn
      AWS_ROLE_EC2_ARN                      = var.aviatrix_aws_role_ec2_arn
      ENABLE_SECURITY_GROUP_MANAGEMENT      = var.enable_security_group_management
      AWS_GOV                               = var.aws_gov
      COPILOT_USERNAME                      = var.copilot_username
      COPILOT_PASSWORD                      = var.copilot_password
    }
  }
}