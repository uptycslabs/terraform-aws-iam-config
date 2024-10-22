resource "aws_iam_role" "role" {
  name = "${var.resource_prefix}-IntegrationRole"
  path = "/"

  assume_role_policy = <<EOF
{
	"Version": "2012-10-17",
	"Statement": [{
		"Action": "sts:AssumeRole",
		"Principal": {
			"AWS": "${var.aws_account_id}"
		},
		"Condition": {
			"StringEquals": {
				"sts:ExternalId": "${var.external_id}"
			}
		},
		"Effect": "Allow",
		"Sid": ""
	}]
}
EOF

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "viewaccesspolicy_attach" {
  policy_arn = "arn:aws:iam::aws:policy/job-function/ViewOnlyAccess"
  role       = aws_iam_role.role.name

}

resource "aws_iam_role_policy_attachment" "securityauditpolicy_attach" {
  policy_arn = "arn:aws:iam::aws:policy/SecurityAudit"
  role       = aws_iam_role.role.name

}

resource "aws_iam_role_policy_attachment" "ReadOnlyPolicy_attach" {
  policy_arn = aws_iam_policy.ReadOnlyPolicy.arn
  role       = aws_iam_role.role.name

}

resource "aws_iam_policy" "ReadOnlyPolicy" {
  name        = "${var.resource_prefix}-ReadOnlyPolicy"
  description = "Given Read Only policy Access to service."
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
              "aoss:BatchGet*",
              "aoss:Get*",
              "aoss:List*",
              "apigateway:GET",
              "bedrock:Get*",
              "bedrock:List*",
              "ce:GetCostAndUsage",
              "codecommit:GetCommit",
              "codepipeline:ListTagsForResource",
              "ds:ListTagsForResource",
              "docdb-elastic:Get*",
              "docdb-elastic:List*",
              "ec2:SearchTransitGatewayRoutes",
              "eks:DescribeAddon",
              "eks:DescribeFargateProfile",
              "eks:DescribeIdentityProviderConfig",
              "eks:DescribeNodegroup",
              "eks:DescribeUpdate",
              "eks:ListAddons",
              "eks:ListFargateProfiles",
              "eks:ListIdentityProviderConfigs",
              "eks:ListNodegroups",
              "eks:ListTagsForResource",
              "eks:ListUpdates",
              "elasticfilesystem:DescribeFileSystemPolicy",
              "glacier:DescribeJob",
              "glacier:GetDataRetrievalPolicy",
              "glacier:GetJobOutput",
              "glacier:GetVaultNotifications",
              "glacier:ListJobs",
              "glacier:ListTagsForVault",
              "lambda:GetCodeSigningConfig",
              "lambda:GetFunctionCodeSigningConfig",
              "logs:FilterLogEvents",
              "macie2:Describe*",
              "macie2:Get*",
              "macie2:List*",
              "ram:GetResourceShares",
              "ram:ListResources",
              "redshift-serverless:List*",
              "s3:GetIntelligentTieringConfiguration",
              "servicecatalog:DescribePortfolio",
              "servicecatalog:DescribeProductAsAdmin",
              "servicecatalog:DescribeProvisioningArtifact",
              "servicecatalog:DescribeServiceAction",
              "servicecatalog:SearchProductsAsAdmin",
              "sns:GetSubscriptionAttributes",
              "ssm:ListCommandInvocations"
            ],
            "Resource": "*"
        }
    ]
}
EOF

  tags = var.tags
}


resource "aws_iam_role_policy_attachment" "cloudtrail_bucket_policy_attach" {
  # Only required when customer wants to  attach the bucket for cloudtrail logs
  count      = var.cloudtrail_log_bucket_arn != null ? 1 : 0
  role       = aws_iam_role.role.name
  policy_arn = aws_iam_policy.cloud_trail_bucketPolicy[0].arn

}

resource "aws_iam_policy" "cloud_trail_bucketPolicy" {
  #  Only required when customer wants to  attach the bucket for cloudtrail logs
  count       = var.cloudtrail_log_bucket_arn != null ? 1 : 0
  name        = "${var.resource_prefix}-cloudtrail-bucket-policy"
  description = "Cloudtrail Bucket Policy "
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [ "s3:GetObject" ],
            "Resource": [ "${var.cloudtrail_log_bucket_arn}/*" ]
        }
    ]
}
EOF

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "VpcFlowLogBucketPolicy_attach" {
  # Only required when customer wants to  attach the bucket for vpc flow logs
  count      = var.vpc_log_bucket_arn != null ? 1 : 0
  role       = aws_iam_role.role.name
  policy_arn = aws_iam_policy.VpcFlowLogBucketPolicy[0].arn

}

resource "aws_iam_policy" "VpcFlowLogBucketPolicy" {
  # Only required when customer wants to  attach the bucket for vpc flow logs
  count       = var.vpc_log_bucket_arn != null ? 1 : 0
  name        = "${var.resource_prefix}-vpc-flowlog-bucket-policy"
  description = "Vpc Flow Log Bucket Policy "
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [ "s3:GetObject" ],
            "Resource": [ "${var.vpc_log_bucket_arn}/*" ]
        }
    ]
}
EOF

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "kinesis_stream_policy_attach" {
  # Only required when customer wants to  attach the kinesis stream for cloudtrail logs
  count      = var.kinesis_stream_arn != null ? 1 : 0
  role       = aws_iam_role.role.name
  policy_arn = aws_iam_policy.kinesis_stream_policy[0].arn

}

resource "aws_iam_policy" "kinesis_stream_policy" {
  # Only required when customer wants to  attach the kinesis stream for cloudtrail logs
  count       = var.kinesis_stream_arn != null ? 1 : 0
  name        = "${var.resource_prefix}-kinesis-stream-policy"
  description = "Kinesis Stream Policy "
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [ 
              "kinesis:GetShardIterator", 
              "kinesis:GetRecords"
            ],
            "Resource": [ "${var.kinesis_stream_arn}" ]
        }
    ]
}
EOF

  tags = var.tags
}
