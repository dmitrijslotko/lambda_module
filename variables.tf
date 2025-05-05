variable "main_config" {
  type = object({
    filename              = string
    function_name         = string
    description           = optional(string, "created by a lambda module"),
    handler               = optional(string, "bootstrap"),
    runtime               = optional(string, "provided.al2023"),
    memory_size           = optional(number, 128),
    timeout               = optional(number, 10),
    publish               = optional(bool, true),
    tags                  = optional(map(string), null),
    layers                = optional(list(string), null),
    architecture          = optional(string, "arm64")
    environment_variables = optional(map(string), null),
  })

  validation {
    condition     = length(var.main_config.function_name) <= 64
    error_message = "The name of the Lambda function, up to 64 characters in length."
  }

  validation {
    condition     = var.main_config.memory_size >= 128 && var.main_config.memory_size <= 10240
    error_message = "Memory size should be between 128 and 10240."
  }
}
variable "log_group_config" {
  type = object({
    retention_in_days = number
  })
  default = {
    retention_in_days = 7,
  }
  validation {
    condition     = var.log_group_config.retention_in_days >= 1
    error_message = "Retention in days must be greater than or equal to 1"
  }
}
variable "vpc_config" {
  type = object({
    subnet_ids         = list(string)
    security_group_ids = list(string)
  })

  default = null
}
