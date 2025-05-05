resource "aws_iam_role_policy" "cloudwatch_logs_policy" {
  name = "cloudwatch_logs_policy"
  role = aws_iam_role.lambda_role.id
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [{
        "Action" : [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource" : "${aws_cloudwatch_log_group.log_group.arn}:*",
        "Effect" : "Allow"
        },
        {
          "Action" : [
            "kms:Encrypt",
            "kms:Decrypt",
            "kms:ReEncrypt*"
          ],
          "Resource" : "*",
          "Effect" : "Allow"
      }]
  })
}

output "cloudwatch_logs_policy" {
  value = aws_iam_role_policy.cloudwatch_logs_policy
}
