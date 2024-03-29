
resource "aws_lambda_function" "rotateKeyMaterialDev" {
  architectures = [var.lambda_arch]
  description   = "custom lambda function that rotates key material and allows keeping track of old key versions"
  filename      = data.archive_file.rotate_key_material_dev.output_path
  function_name = local.rotate_function_name
  handler       = "${local.rotate_function_name}.handler"
  kms_key_arn   = null
  layers = [
    "arn:aws:lambda:us-west-1:997803712105:layer:AWS-Parameters-and-Secrets-Lambda-Extension:11",
    aws_lambda_layer_version.x-ray_for_node.arn
  ]
  memory_size                    = 128
  package_type                   = "Zip"
  publish                        = null
  reserved_concurrent_executions = -1
  role                           = "arn:aws:iam::021427789578:role/service-role/${local.post_signup_conf_fname}-role-gl9reck2"
  runtime                        = var.node_runtime
  skip_destroy                   = false
  source_code_hash               = data.archive_file.rotate_key_material_dev.output_base64sha256
  timeout                        = 5
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

data "archive_file" "rotate_key_material_dev" {
  type        = "zip"
  source_file = "${path.module}/${local.rotate_lambda_dir}/${local.rotate_function_name}.mjs"
  output_path = "${path.module}/${var.zip_dir}/lambda/node/${local.rotate_filename}"
}

locals {
  rotate_filename      = "${local.rotate_function_name}_payload.zip"
  rotate_function_name = "RotateKeyMaterial"
  rotate_lambda_dir    = "${var.lambda-dir}/triggered-by-ssm/on-parameter-expiration"
}

# Trust Relationships
#{
#"Version": "2012-10-17",
#"Statement": [
#{
#"Effect": "Allow",
#"Principal": {
#"Service": "lambda.amazonaws.com"
#},
#"Action": "sts:AssumeRole"
#}
#]
#}


#{
#"Version": "2012-10-17",
#"Statement": [
#{
#"Effect": "Allow",
#"Action": "logs:CreateLogGroup",
#"Resource": "arn:aws:logs:us-west-1:021427789578:*"
#},
#{
#"Effect": "Allow",
#"Action": [
#"logs:CreateLogStream",
#"logs:PutLogEvents"
#],
#"Resource": [
#"arn:aws:logs:us-west-1:021427789578:log-group:/aws/lambda/PostSignUpConfirmationV2:*"
#]
#},
#{
#"Sid": "Statement1",
#"Effect": "Allow",
#"Action": [
#"dynamodb:*"
#],
#"Resource": [
#"arn:aws:dynamodb:us-west-1:021427789578:table/USERS_LIKED_ITEMS_DEV"
#]
#},
#{
#"Sid": "UpdategoogleRefeshTokenAttribute",
#"Effect": "Allow",
#"Action": [
#"cognito-idp:AdminUpdateUserAttributes"
#],
#"Resource": [
#"arn:aws:cognito-idp:us-west-1:021427789578:userpool/us-west-1_DMqCcn38p"
#]
#},
#{
#"Sid": "Statement2",
#"Effect": "Allow",
#"Action": [
#"ssm:GetParameter",
#"ssm:PutParameter"
#],
#"Resource": [
#"arn:aws:ssm:us-west-1:021427789578:*"
#]
#},
#{
#"Sid": "Statement3",
#"Effect": "Allow",
#"Action": [
#"kms:Decrypt"
#],
#"Resource": [
#"arn:aws:kms:us-east-1:021427789578:key/45811c46-2a5a-444b-aba1-7fe69a89111c"
#]
#}
#]
#}
