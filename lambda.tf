resource "aws_lambda_function" "lambda" {
  filename      = var.main_config.filename
  function_name = var.main_config.function_name
  role          = aws_iam_role.lambda_role.arn
  handler       = var.main_config.handler
  runtime       = var.main_config.runtime
  memory_size   = var.main_config.memory_size
  timeout       = var.main_config.timeout
  publish       = var.main_config.publish
  tags          = var.main_config.tags
  layers        = var.main_config.layers
  architectures = [var.main_config.architecture]

  dynamic "environment" {
    for_each = var.main_config.environment_variables != null ? [1] : []
    content {
      variables = merge(var.main_config.environment_variables, {})
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
