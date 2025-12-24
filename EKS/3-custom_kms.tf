resource "aws_kms_key" "eks_nodes" {
  description         = "KMS key for EKS worker nodes"
  enable_key_rotation = true

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowRoot",
      "Effect": "Allow",
      "Principal": { "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root" },
      "Action": "kms:*",
      "Resource": "*"
    },
    {
      "Sid": "AllowEC2AndASG",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:ReEncrypt*",
        "kms:CreateGrant",
        "kms:DescribeKey",
        "kms:GenerateDataKey*"
      ],
      "Resource": "*",
      "Condition": {
        "StringEquals": {
          "kms:ViaService": [
            "ec2.${local.region}.amazonaws.com",
            "autoscaling.${local.region}.amazonaws.com"
          ]
        }
      }
    }
  ]
}
POLICY
}