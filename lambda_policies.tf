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

resource "aws_iam_role_policy" "vpc_policy" {
  count = var.vpc_config == null ? 0 : 1
  name  = "vpc_policy"
  role  = aws_iam_role.lambda_role.id
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "ec2:CreateNetworkInterface",
            "ec2:DescribeNetworkInterfaces",
            "ec2:DeleteNetworkInterface",
            "ec2:AssignPrivateIpAddresses",
            "ec2:UnassignPrivateIpAddresses",
            "ec2:DescribeSecurityGroups",
            "ec2:DescribeSubnets",
            "ec2:DescribeVpcs",
          ],
          "Resource" : "*"
        }
      ]
  })
}

resource "aws_lambda_permission" "api_permissions" {
  count         = var.http_event_trigger == null ? 0 : 1
  statement_id  = "AllowAPIGatewayInvokeMyLambdaHTTPAPI"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = var.http_event_trigger.url
  qualifier     = aws_lambda_function.lambda.version
}

output "cloudwatch_logs_policy" {
  value = aws_iam_role_policy.cloudwatch_logs_policy
}

output "vpc_policy" {
  value = aws_iam_role_policy.vpc_policy
}
