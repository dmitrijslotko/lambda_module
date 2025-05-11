resource "aws_lambda_function" "lambda" {
  filename         = data.archive_file.lambda_source.output_path
  function_name    = var.main_config.function_name
  role             = aws_iam_role.lambda_role.arn
  handler          = var.main_config.handler
  runtime          = var.main_config.runtime
  memory_size      = var.main_config.memory_size
  timeout          = var.main_config.timeout
  publish          = var.main_config.publish
  tags             = var.main_config.tags
  layers           = var.main_config.layers
  architectures    = [var.main_config.architecture]
  source_code_hash = data.archive_file.lambda_source.output_base64sha256

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

resource "null_resource" "run_make_file" {
  # Triggers re-execution of local-exec when source code hash changes
  triggers = {
    trigger = timestamp()
  }

  provisioner "local-exec" {
    command = "make -C ${var.main_config.filename} lambda GOARCH=${var.main_config.architecture}"
  }
}

data "archive_file" "lambda_source" {
  type        = "zip"
  source_dir  = "${var.main_config.filename}/.build"
  output_path = "${path.module}/.build/${var.main_config.function_name}.zip"
  depends_on  = [null_resource.run_make_file]
}

output "lambda" {
  value = aws_lambda_function.lambda
}
