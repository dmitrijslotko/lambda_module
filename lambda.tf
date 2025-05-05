resource "aws_lambda_function" "lambda" {
  filename         = var.config.filename
  function_name    = var.config.function_name
  role             = aws_iam_role.lambda_role.arn
  handler          = var.config.handler
  source_code_hash = filebase64sha256(var.config.filename)
  runtime          = var.config.runtime
  memory_size      = var.config.memory_size
  timeout          = var.config.timeout
  publish          = var.config.publish
  tags             = var.config.tags
  layers           = var.config.layers
  architectures    = [var.config.architecture]

  dynamic "environment" {
    for_each = var.config.environment_variables != null ? [1] : []
    content {
      variables = merge(var.config.environment_variables, {})
    }
  }

  dynamic "vpc_config" {
    for_each = var.vpc_config == null ? [] : ["a sigle element to trigger the block"]
    content {
      subnet_ids         = var.vpc_config.subnet_ids
      security_group_ids = var.vpc_config.security_group_ids
    }
  }
}
