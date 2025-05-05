resource "aws_cloudwatch_log_group" "log_group" {
  name              = "/aws/lambda/${var.main_config.function_name}"
  retention_in_days = var.log_group_config.retention_in_days
  tags              = var.main_config.tags
}
