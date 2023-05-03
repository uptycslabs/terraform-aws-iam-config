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
              "apigateway:GET",
              "codebuild:BatchGetProjects",
	      "codebuild:ListProjects",
              "codecommit:GetBranch",
              "codecommit:GetCommit",
              "codecommit:GetRepository",
              "codepipeline:GetPipeline",
              "codepipeline:ListTagsForResource",
              "ds:ListTagsForResource",
              "ec2:DescribeAccountAttributes",
              "ec2:GetEbsEncryptionByDefault",
              "ec2:SearchTransitGatewayRoutes",
              "ec2:GetTransitGatewayMulticastDomainAssociations",
              "eks:DescribeAddon",
              "eks:DescribeCluster",
              "eks:DescribeFargateProfile",
              "eks:DescribeIdentityProviderConfig",
              "eks:DescribeNodegroup",
              "eks:DescribeUpdate",
              "eks:ListAddons",
              "eks:ListClusters",
              "eks:ListFargateProfiles",
              "eks:ListIdentityProviderConfigs",
              "eks:ListNodegroups",
              "eks:ListTagsForResource",
              "eks:ListUpdates",
              "elasticache:ListTagsForResource",
              "elasticfilesystem:DescribeFileSystemPolicy",
              "es:ListTags",
              "glacier:DescribeJob",
              "glacier:DescribeVault",
              "glacier:GetDataRetrievalPolicy",
              "glacier:GetJobOutput",
              "glacier:GetVaultAccessPolicy",
              "glacier:GetVaultLock",
              "glacier:GetVaultNotifications",
              "glacier:ListJobs",
              "glacier:ListTagsForVault",
              "glacier:ListVaults",
              "kinesis:DescribeStream",
              "logs:FilterLogEvents",
              "ram:GetResourceShares",
              "ram:ListResources",
              "s3:GetIntelligentTieringConfiguration",
              "secretsmanager:DescribeSecret",
              "servicecatalog:DescribePortfolio",
              "servicecatalog:DescribeProductAsAdmin",
              "servicecatalog:DescribeProvisioningArtifact",
              "servicecatalog:DescribeServiceAction",
              "servicecatalog:SearchProductsAsAdmin",
              "sns:GetSubscriptionAttributes",
              "sns:GetTopicAttributes",
              "sns:ListSubscriptionsByTopic",
              "sns:ListTagsForResource",
              "sns:ListTopics",
              "sqs:GetQueueAttributes",
              "sqs:ListQueueTags",
              "sqs:ListQueues",
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
