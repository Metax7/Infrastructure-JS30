resource "aws_lambda_function" "postSignUpConfirmationV2" {
  architectures = [var.lambda_arch]
  description   = "Cognito Post Confirmation Trigger. Adds a new user with a set of 0 liked items to DynamoDB"
  filename      = data.archive_file.archive_post_signup_conf_dev.output_path
  function_name = local.post_signup_conf_fname
  handler       = "${local.post_signup_conf_fname}.handler"
  kms_key_arn   = null
  layers = [
    "arn:aws:lambda:us-west-1:997803712105:layer:AWS-Parameters-and-Secrets-Lambda-Extension:11",
    aws_lambda_layer_version.axios_for_node.arn,
    aws_lambda_layer_version.x-ray_for_node.arn
  ]
  memory_size                    = 128
  package_type                   = "Zip"
  publish                        = null
  reserved_concurrent_executions = -1
  role                           = "arn:aws:iam::021427789578:role/service-role/${local.post_signup_conf_fname}-role-gl9reck2"
  runtime                        = var.node_runtime
  skip_destroy                   = false
  source_code_hash               = data.archive_file.archive_post_signup_conf_dev.output_base64sha256

  timeout = 3
  ephemeral_storage {
    size = 512
  }
  tracing_config {
    mode = "Active"
  }
  environment {
    variables = {
      SSM_PARAMETER_STORE_TTL = 300
      ENV                     = "dev"
      LOG_LEVEL               = "info"
    }
  }
}

data "archive_file" "archive_post_signup_conf_dev" {
  type        = "zip"
  source_file = "${path.module}/${local.post_signup_conf_dir}/${local.post_signup_conf_fname}.mjs"
  output_path = "${path.module}/${var.zip_dir}/lambda/node/${local.on-sign-up-filename}"
}

locals {
  on-sign-up-filename    = "${local.post_signup_conf_fname}_payload.zip"
  post_signup_conf_fname = "PostSignUpConfirmationV2"
  post_signup_conf_dir   = "${var.lambda-dir}/triggered-by-cognito-userpool/on-sign-up"
}
