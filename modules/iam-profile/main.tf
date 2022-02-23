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
              "codecommit:GetCommit",
              "codecommit:GetRepository",
              "codecommit:GetBranch",
              "codepipeline:ListTagsForResource",
              "codepipeline:GetPipeline",
              "ds:ListTagsForResource",
              "eks:ListNodegroups",
              "eks:DescribeFargateProfile",
              "eks:ListTagsForResource",
              "eks:ListAddons",
              "eks:DescribeAddon",
              "eks:ListFargateProfiles",
              "eks:DescribeNodegroup",
              "eks:DescribeIdentityProviderConfig",
              "eks:ListUpdates",
              "eks:DescribeUpdate",
              "eks:DescribeCluster",
              "eks:ListClusters",
              "eks:ListIdentityProviderConfigs",
              "elasticache:ListTagsForResource",
              "es:ListTags",
              "glacier:GetDataRetrievalPolicy",
              "glacier:ListJobs",
              "glacier:GetVaultAccessPolicy",
              "glacier:ListTagsForVault",
              "glacier:DescribeVault",
              "glacier:GetJobOutput",
              "glacier:GetVaultLock",
              "glacier:ListVaults",
              "glacier:GetVaultNotifications",
              "glacier:DescribeJob",
              "kinesis:DescribeStream",
              "logs:FilterLogEvents",
              "ram:ListResources",
              "ram:GetResourceShares",
              "secretsmanager:DescribeSecret",
              "servicecatalog:SearchProductsAsAdmin",
              "servicecatalog:DescribeProductAsAdmin",
              "servicecatalog:DescribePortfolio",
              "servicecatalog:DescribeServiceAction",
              "servicecatalog:DescribeProvisioningArtifact",
              "sns:ListTagsForResource",
              "sns:ListSubscriptionsByTopic",
              "sns:GetTopicAttributes",
              "sns:ListTopics",
              "sns:GetSubscriptionAttributes",
              "sqs:ListQueues",
              "sqs:GetQueueAttributes",
              "sqs:ListQueueTags"
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
