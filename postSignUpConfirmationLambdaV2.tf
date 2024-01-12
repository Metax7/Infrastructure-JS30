# __generated__ by Terraform
# Please review these resources and move them into your main configuration files.

# __generated__ by Terraform
resource "aws_lambda_function" "postSignUpConfirmationV2" {
  architectures                  = ["x86_64"]
  description                    = "Cognito Post Confirmation Trigger. Adds a new user with a set of 0 liked items to DynamoDB"
  filename                       = local.filename
  function_name                  = local.function_name
  handler                        = "${local.function_name}.handler"
  kms_key_arn                    = null
  layers                         = []
  memory_size                    = 128
  package_type                   = "Zip"
  publish                        = null
  reserved_concurrent_executions = -1
  role                           = "arn:aws:iam::021427789578:role/service-role/${local.function_name}-role-gl9reck2"
  runtime                        = "nodejs20.x"
  skip_destroy                   = false
  source_code_hash               = data.archive_file.postSignUpConfirmationLambda.output_base64sha256
  tags = {
    Created = "manually"
  }
  tags_all = {
    Created = "manually"
  }
  timeout = 3
  ephemeral_storage {
    size = 512
  }
  tracing_config {
    mode = "PassThrough"
  }
}

data "archive_file" "postSignUpConfirmationLambda" {
  type        = "zip"
  source_file = "./LambdasTriggeredByCognito/Sign-Up/${local.function_name}.mjs"
  output_path = local.filename
}

locals {
  filename      = "PostSignUpConfirmationV2_payload.zip"
  function_name = "PostSignUpConfirmationV2"
}
