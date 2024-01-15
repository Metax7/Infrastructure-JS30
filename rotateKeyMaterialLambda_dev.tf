
resource "aws_lambda_function" "rotateKeyMaterialDev" {
  architectures                  = ["x86_64"]
  description                    = "custom lambda function that rotates key material and allows keeping track of old key versions"
  filename                       = "${path.module}/${local.rotate_lambda_dir}/${local.rotate_filename}"
  function_name                  = local.rotate_function_name
  handler                        = "${local.rotate_function_name}.handler"
  kms_key_arn                    = null
  layers                         = ["arn:aws:lambda:us-west-1:997803712105:layer:AWS-Parameters-and-Secrets-Lambda-Extension:11", aws_lambda_layer_version.nodejs_layer_dev.arn]
  memory_size                    = 128
  package_type                   = "Zip"
  publish                        = null
  reserved_concurrent_executions = -1
  role                           = ""
  runtime                        = "nodejs20.x"
  skip_destroy                   = false
  source_code_hash               = data.archive_file.rotate_key_material_dev.output_base64sha256
  timeout                        = 5
  ephemeral_storage {
    size = 512
  }
  tracing_config {
    mode = "PassThrough"
  }
}

data "archive_file" "rotate_key_material_dev" {
  type        = "zip"
  source_file = "${path.module}/${local.rotate_lambda_dir}/${local.rotate_function_name}.mjs"
  output_path = "${path.module}/${local.rotate_lambda_dir}/${local.rotate_filename}"
}

locals {
  rotate_filename       = "${local.rotate_function_name}_payload.zip"
  rotate_function_name  = "RotateKeyMaterial"
  rotate_layer_filename = "cognito_nodejs_layer"
  rotate_lambda_dir     = "LambdasTriggeredBySSM/SSMParameterExpiration"
}
