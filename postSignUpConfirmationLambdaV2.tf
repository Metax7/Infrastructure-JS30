resource "aws_lambda_function" "postSignUpConfirmationV2" {
  architectures                  = ["x86_64"]
  description                    = "Cognito Post Confirmation Trigger. Adds a new user with a set of 0 liked items to DynamoDB"
  filename                       = "${path.module}/${local.trigger_dir_name}/Sign-Up/${local.filename}"
  function_name                  = local.function_name
  handler                        = "${local.function_name}.handler"
  kms_key_arn                    = null
  layers                         = ["arn:aws:lambda:us-west-1:997803712105:layer:AWS-Parameters-and-Secrets-Lambda-Extension:11", aws_lambda_layer_version.nodejs_layer_dev.arn]
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
  environment {
    variables = {
      SSM_PARAMETER_STORE_TTL = 3600
    }
  }
}

resource "aws_lambda_layer_version" "nodejs_layer_dev" {
  filename                 = "${path.module}/${local.trigger_dir_name}/${local.layer_filename}.zip"
  layer_name               = "nodejs_layer_dev"
  compatible_architectures = ["x86_64"]
  compatible_runtimes      = ["nodejs20.x"]
  source_code_hash         = data.archive_file.cognitoLambdaLayer.output_base64sha256
  skip_destroy             = true // this should make aws increment layer version instead of replacing. Additional charges may occure!

}

resource "null_resource" "build_cognitolayer" {
  # triggers = {
  #   build_number = "${timestamp()}"
  # }
  provisioner "local-exec" {
    command     = "sh buildlayer.sh"
    working_dir = "${path.module}/${local.trigger_dir_name}"

  }
}

data "archive_file" "cognitoLambdaLayer" {
  depends_on  = [null_resource.build_cognitolayer]
  type        = "zip"
  source_dir  = "${path.module}/${local.trigger_dir_name}/${local.layer_filename}"
  output_path = "${path.module}/${local.trigger_dir_name}/${local.layer_filename}.zip"
}

data "archive_file" "postSignUpConfirmationLambda" {
  type        = "zip"
  source_file = "${path.module}/${local.trigger_dir_name}/Sign-Up/${local.function_name}.mjs"
  output_path = "${path.module}/${local.trigger_dir_name}/Sign-Up/${local.filename}"
}

locals {
  filename         = "PostSignUpConfirmationV2_payload.zip"
  function_name    = "PostSignUpConfirmationV2"
  layer_filename   = "cognito_nodejs_layer"
  trigger_dir_name = "LambdasTriggeredByCognito"
}
