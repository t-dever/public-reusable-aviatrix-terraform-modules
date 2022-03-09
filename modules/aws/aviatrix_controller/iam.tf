# Create IAM Role for Managing EC2 Instances
resource "aws_iam_role" "aviatrix_role_ec2" {
  name               = "aviatrix-role-ec2"
  description        = "Aviatrix EC2 Role - Created by Terraform"
  path               = "/"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
         "Effect": "Allow",
         "Principal": {
           "Service": [
              "ec2.amazonaws.com"
           ]
         },
         "Action": [
           "sts:AssumeRole"
         ]
       }
    ]
}
EOF
}

# Create IAM Role for Aviatrix App Controller
resource "aws_iam_role" "aviatrix_role_app" {
  name               = "aviatrix-role-app"
  description        = "Aviatrix APP Role - Created by Terraform"
  path               = "/"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "AWS": [
              "arn:${var.arn_partition}:iam::${data.aws_caller_identity.current.account_id}:root"
            ]
        },
        "Action": [
          "sts:AssumeRole"
        ]
      }
    ]
}
EOF
}

# Create IAM Policy for assuming role and accepting marketplace AMI.
resource "aws_iam_policy" "aviatrix_assume_role_policy" {
  name        = "aviatrix-role-ec2-assume-role-policy"
  path        = "/"
  description = "Policy to Assume App Role - Created by Terraform"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "sts:AssumeRole"
            ],
            "Resource": "${aws_iam_role.aviatrix_role_app.arn}"
        },
        {
            "Effect": "Allow",
            "Action": [
                "aws-marketplace:MeterUsage",
                "s3:GetBucketLocation"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

# Create IAM Policy for Aviatrix App to deploy resources.
resource "aws_iam_policy" "aviatrix_app_policy" {
  name        = "aviatrix-role-app-policy"
  path        = "/"
  description = "Policy to deploy resources - Created by Terraform"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:Describe*",
                "ec2:Get*",
                "ec2:Search*",
                "elasticloadbalancing:Describe*",
                "route53:List*",
                "route53:Get*",
                "sqs:Get*",
                "sqs:List*",
                "sns:List*",
                "s3:List*",
                "s3:Get*",
                "iam:List*",
                "iam:Get*",
                "directconnect:Describe*",
                "guardduty:Get*",
                "guardduty:List*",
                "ram:Get*",
                "ram:List*",
                "networkmanager:Get*",
                "networkmanager:List*"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:CreateVpc",
                "ec2:DeleteVpc",
                "ec2:ModifyVpcAttribute",
                "ec2:CreateNetworkAclEntry",
                "ec2:ReplaceNetworkAclEntry",
                "ec2:DeleteNetworkAclEntry",
                "ec2:AssociateVpcCidrBlock",
                "ec2:AssociateSubnetCidrBlock",
                "ec2:CreateSubnet",
                "ec2:DeleteSubnet",
                "ec2:ModifySubnetAttribute",
                "ec2:*InternetGateway*",
                "ec2:*Route*",
                "ec2:*Instance*",
                "ec2:*SecurityGroup*",
                "ec2:*Address*",
                "ec2:*NetworkInterface*",
                "ec2:CreateKeyPair",
                "ec2:DeleteKeyPair",
                "ec2:CreateTags",
                "ec2:DeleteTags",
                "ec2:DeleteFlowLogs",
                "ec2:CreateFlowLogs",
                "ec2:DescribeFlowLogs",
                "ec2:AssociateIamInstanceProfile",
                "ec2:DisassociateIamInstanceProfile",
                "ec2:DescribeIamInstanceProfileAssociations"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:CreateCustomerGateway",
                "ec2:DeleteCustomerGateway",
                "ec2:CreateVpnConnection",
                "ec2:DeleteVpnConnection",
                "ec2:CreateVpcPeeringConnection",
                "ec2:AcceptVpcPeeringConnection",
                "ec2:DeleteVpcPeeringConnection",
                "ec2:EnableVgwRoutePropagation",
                "ec2:DisableVgwRoutePropagation"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:AssociateTransitGatewayRouteTable",
                "ec2:AcceptTransitGatewayVpcAttachment",
                "ec2:CreateTransitGateway",
                "ec2:CreateTransitGatewayRoute",
                "ec2:CreateTransitGatewayRouteTable",
                "ec2:CreateTransitGatewayVpcAttachment",
                "ec2:DeleteTransitGateway",
                "ec2:DeleteTransitGatewayRoute",
                "ec2:DeleteTransitGatewayRouteTable",
                "ec2:DeleteTransitGatewayVpcAttachment",
                "ec2:DisableTransitGatewayRouteTablePropagation",
                "ec2:DisassociateTransitGatewayRouteTable",
                "ec2:EnableTransitGatewayRouteTablePropagation",
                "ec2:ExportTransitGatewayRoutes",
                "ec2:ModifyTransitGatewayVpcAttachment",
                "ec2:RejectTransitGatewayVpcAttachment",
                "ec2:ReplaceTransitGatewayRoute",
                "ec2:ModifyTransitGateway",
                "ec2:CreateTransitGatewayConnect",
                "ec2:DeleteTransitGatewayConnect",
                "ec2:CreateTransitGatewayConnectPeer",
                "ec2:DeleteTransitGatewayConnectPeer",
                "ec2:CreateVpcEndpoint",
                "ec2:DeleteVpcEndpoints",
                "ec2:CreateVpcEndpointServiceConfiguration",
                "ec2:DeleteVpcEndpointServiceConfigurations",
                "ec2:CreateNatGateway",
                "ec2:DeleteNatGateway"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ram:CreateResourceShare",
                "ram:DeleteResourceShare",
                "ram:UpdateResourceShare",
                "ram:AssociateResourceShare",
                "ram:DisassociateResourceShare",
                "ram:TagResource",
                "ram:UntagResource",
                "ram:AcceptResourceShareInvitation",
                "ram:EnableSharingWithAwsOrganization"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "directconnect:CreateDirectConnectGateway",
                "directconnect:CreateDirectConnectGatewayAssociation",
                "directconnect:CreateDirectConnectGatewayAssociationProposal",
                "directconnect:DeleteDirectConnectGateway",
                "directconnect:DeleteDirectConnectGatewayAssociation",
                "directconnect:DeleteDirectConnectGatewayAssociationProposal",
                "directconnect:AcceptDirectConnectGatewayAssociationProposal"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "sqs:AddPermission",
                "sqs:ChangeMessageVisibility",
                "sqs:CreateQueue",
                "sqs:DeleteMessage",
                "sqs:DeleteQueue",
                "sqs:PurgeQueue",
                "sqs:ReceiveMessage",
                "sqs:RemovePermission",
                "sqs:SendMessage",
                "sqs:SetQueueAttributes",
                "sqs:TagQueue"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:CreateBucket",
                "s3:DeleteBucket",
                "s3:ListBucket",
                "s3:PutObject",
                "s3:DeleteObject",
                "s3:PutBucketPolicy",
                "s3:DeleteBucketPolicy"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogDelivery",
                "logs:DeleteLogDelivery"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "servicequotas:GetAWSDefaultServiceQuota",
                "servicequotas:GetServiceQuota",
                "servicequotas:ListAWSDefaultServiceQuotas",
                "servicequotas:ListServiceQuotas",
                "servicequotas:ListServices"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "iam:PassRole",
                "iam:AddRoleToInstanceProfile",
                "iam:CreateInstanceProfile",
                "iam:DeleteInstanceProfile",
                "iam:RemoveRoleFromInstanceProfile",
                "iam:CreateServiceLinkedRole",
                "iam:TagInstanceProfile"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "iam:DeletePolicyVersion",
                "iam:CreatePolicyVersion"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "elasticloadbalancing:*",
                "route53:ChangeResourceRecordSets",
                "ec2:*Volume*",
                "ec2:*Snapshot*",
                "ec2:*TransitGatewayPeeringAttachment",
                "guardduty:*",
                "globalaccelerator:*",
                "networkmanager:*"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "lambda:GetFunction"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}


# Attach EC2 Role to Assume Role Policy
resource "aws_iam_role_policy_attachment" "aviatrix_role_ec2_attach" {
  role       = aws_iam_role.aviatrix_role_ec2.name
  policy_arn = aws_iam_policy.aviatrix_assume_role_policy.arn
}

# Attach App Role to App Policy
resource "aws_iam_role_policy_attachment" "aviatrix_role_app_attach" {
  role       = aws_iam_role.aviatrix_role_app.name
  policy_arn = aws_iam_policy.aviatrix_app_policy.arn
}

# TODO figure out what this is used for.
resource "aws_iam_instance_profile" "aviatrix_role_ec2_profile" {
  name = aws_iam_role.aviatrix_role_ec2.name
  role = aws_iam_role.aviatrix_role_ec2.name
}

