resource "aws_lambda_function" "xChangeIdpRefreshToken_dev" {
  architectures                  = ["x86_64"]
  description                    = "xChanges encrypted google_refresh_token to refreshed access_token"
  filename                       = "${path.module}/${var.lambdas_by_gw_dir}/${local.xchange_refresh_filename}"
  function_name                  = local.xchange_refresh_function_name
  handler                        = "${local.xchange_refresh_function_name}.handler"
  kms_key_arn                    = null
  layers                         = ["arn:aws:lambda:us-west-1:997803712105:layer:AWS-Parameters-and-Secrets-Lambda-Extension:11", aws_lambda_layer_version.nodejs_layer_dev.arn]
  memory_size                    = 128
  package_type                   = "Zip"
  publish                        = null
  reserved_concurrent_executions = -1
  role                           = "arn:aws:iam::021427789578:role/service-role/${local.function_name}-role-gl9reck2"
  runtime                        = "nodejs20.x"
  skip_destroy                   = false
  source_code_hash               = data.archive_file.xchange_refresh_token_dev.output_base64sha256
  tags = {
    Created = "manually"
  }
  tags_all = {
    Created = "manually"
  }
  timeout = 6
  ephemeral_storage {
    size = 512
  }
  tracing_config {
    mode = "PassThrough"
  }
  environment {
    variables = {
      SSM_PARAMETER_STORE_TTL = 300
      REVOKED_KEY_VERSIONS    = jsonencode([1, 2])
    }
  }
}

data "archive_file" "xchange_refresh_token_dev" {
  type        = "zip"
  source_file = "${path.module}/${var.lambdas_by_gw_dir}/${local.xchange_refresh_function_name}.mjs"
  output_path = "${path.module}/${var.lambdas_by_gw_dir}/${local.xchange_refresh_filename}"
}

locals {
  xchange_refresh_filename      = "${local.xchange_refresh_function_name}_payload.zip"
  xchange_refresh_function_name = "XChangeRefeshTokenToAccess"
}
