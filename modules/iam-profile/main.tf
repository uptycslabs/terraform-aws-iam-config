resource "aws_iam_role" "role" {
  #provider = aws.orgrole
  name = "${var.child_account_id}-uptycs-samp-IntegrationRole"
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
  #provider = aws.orgrole
  policy_arn = "arn:aws:iam::aws:policy/job-function/ViewOnlyAccess"
  role       = aws_iam_role.role.name

}

resource "aws_iam_role_policy_attachment" "securityauditpolicy_attach" {
  #provider = aws.orgrole
  policy_arn = "arn:aws:iam::aws:policy/SecurityAudit"
  role       = aws_iam_role.role.name

}

resource "aws_iam_role_policy_attachment" "ReadOnlyPolicy_attach" {
  #provider = aws.orgrole
  policy_arn = aws_iam_policy.ReadOnlyPolicy.arn
  role       = aws_iam_role.role.name

}

resource "aws_iam_policy" "ReadOnlyPolicy" {
  #provider = aws.orgrole
  name        = "${var.child_account_id}-uptycs-samp-ReadOnlyPolicy"
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
