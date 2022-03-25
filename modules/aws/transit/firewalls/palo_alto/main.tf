# Generates a random ID for S3 Bucket if name is not specified
resource "random_id" "s3_bucket_random_id" {
  count       = length(var.s3_bucket_name) > 0 ? 0 : 1
  byte_length = 8
}

# Generates a random password if password is not provided
resource "random_password" "aviatrix_firewall_admin_password" {
  count            = length(var.firewall_password) > 0 ? 0 : 1
  length           = 24
  special          = true
  min_lower        = 2
  min_numeric      = 2
  min_special      = 2
  min_upper        = 2
  override_special = "_@$*()!"
}

# Stores the generated credential as an AWS Systems Management (SSM) Secret Parameter
resource "aws_ssm_parameter" "aviatrix_palo_alto_secret_parameter" {
  count       = var.store_firewall_password_in_ssm ? 1 : 0
  name        = "/aviatrix/firenet/password"
  description = "The password used for palo alto firewalls."
  type        = "SecureString"
  value       = length(var.firewall_password) > 0 ? var.firewall_password : random_password.aviatrix_firewall_admin_password[0].result
  tags        = { "Name" = "palo-alto-local-password" }
}

# Creates S3 Bucket for Bootstrap Config
resource "aws_s3_bucket" "s3_bucket" {
  #checkov:skip=CKV_AWS_145:"Ensure that S3 buckets are encrypted with KMS by default" REASON: No sensitive information availabile
  #checkov:skip=CKV_AWS_144:"Ensure that S3 bucket has cross-region replication enabled" REASON: Replication not required
  #checkov:skip=CKV_AWS_21: "Ensure all data stored in the S3 bucket have versioning enabled" REASON: Versioning is enabled by 'aws_s3_bucket_versioning.s3_versioning' resource
  #checkov:skip=CKV_AWS_18: "Ensure the S3 bucket has access logging enabled" REASON: Logging is enabled by 'aws_s3_bucket_logging.s3_logging' resource
  #checkov:skip=CKV_AWS_19: "Ensure all data stored in the S3 bucket is securely encrypted at rest" REASON: Encryption is enabled by 'aws_s3_bucket_server_side_encryption_configuration.s3_encryption' resource
  bucket = local.s3_bucket_name
}

# Enables S3 Bucket Versioning for bootstrap bucket
resource "aws_s3_bucket_versioning" "s3_versioning" {
  bucket = aws_s3_bucket.s3_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Enables S3 Bucket Server Side Encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "s3_encryption" {
  bucket = aws_s3_bucket.s3_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Enables S3 Bucket Logging
resource "aws_s3_bucket_logging" "s3_logging" {
  bucket = aws_s3_bucket.s3_bucket.id

  target_bucket = aws_s3_bucket.s3_bucket.id
  target_prefix = "log/"
}

# Enables S3 Bucket Logging
resource "aws_s3_bucket_public_access_block" "s3_block_public_access" {
  bucket = aws_s3_bucket.s3_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}

# Creates S3 ACL to private
resource "aws_s3_bucket_acl" "s3_acl" {
  bucket = aws_s3_bucket.s3_bucket.id
  acl    = "private"
}

# Creates S3 Bucket Folder for '/content'
resource "aws_s3_object" "bootstrap_content" {
  bucket = aws_s3_bucket.s3_bucket.id
  acl    = "private"
  key    = "content/"
}

# Creates S3 Bucket Folder for '/license'
resource "aws_s3_object" "bootstrap_license" {
  bucket = aws_s3_bucket.s3_bucket.id
  acl    = "private"
  key    = "license/"
}

# Creates S3 Bucket Folder for '/software'
resource "aws_s3_object" "bootstrap_software" {
  bucket = aws_s3_bucket.s3_bucket.id
  acl    = "private"
  key    = "software/"
}

# Creates S3 Bucket Folder for '/config/bootstrap.xml' with bootstrap template.
resource "aws_s3_object" "bootstrap_upload" {
  bucket                 = aws_s3_bucket.s3_bucket.id
  key                    = "config/bootstrap.xml"
  content                = templatefile("${path.module}/bootstrap.tftpl", { public_key = var.aws_key_pair_public_key })
  server_side_encryption = "AES256"
}

# Creates S3 Bucket Folder for '/config/init-cfg.txt' with init-cfg template.
resource "aws_s3_object" "cfg_upload" {
  bucket                 = aws_s3_bucket.s3_bucket.id
  key                    = "config/init-cfg.txt"
  content                = templatefile("${path.module}/init-cfg.tftpl", {})
  server_side_encryption = "AES256"
}

# Creates IAM role to Access S3 Bootstrap Bucket
resource "aws_iam_role" "aviatrix_s3_bootstrap_role" {
  name               = var.s3_iam_role_name
  description        = "Aviatrix S3 Bucket Role - Created by Terraform"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# Creates IAM Policy to Access S3 Bootstrap Bucket
resource "aws_iam_policy" "aviatrix_s3_bootstrap_policy" {
  name   = "${var.s3_iam_role_name}-policy"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket"
            ],
            "Resource": [
                "${aws_s3_bucket.s3_bucket.arn}"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject"
            ],
            "Resource": [
                "${aws_s3_bucket.s3_bucket.arn}/*"
            ]
        }
    ]
}
EOF
}

# Attaches IAM Role to IAM Policy
resource "aws_iam_role_policy_attachment" "aviatrix_bootstrap_role_attach" {
  role       = aws_iam_role.aviatrix_s3_bootstrap_role.name
  policy_arn = aws_iam_policy.aviatrix_s3_bootstrap_policy.arn
}

# Create IAM Instance Profile
resource "aws_iam_instance_profile" "aviatrix_bootstrap_profile" {
  name = var.s3_iam_role_name
  role = aws_iam_role.aviatrix_s3_bootstrap_role.name
}
