resource "aws_ssm_parameter" "cf_distr_id_dev" {
  name  = "${var.parameter_store_prefix}dev/${var.parameter_store_app_prefix}${var.js30_parameters_template["CF_DISTR_ID"].name}"
  type  = var.js30_parameters_template["CF_DISTR_ID"].type
  value = var.js30_parameters_template["CF_DISTR_ID"].value
}

resource "aws_ssm_parameter" "env_dev" {
  name  = "${var.parameter_store_prefix}dev/${var.parameter_store_app_prefix}${var.js30_parameters_template["ENV"].name}"
  type  = var.js30_parameters_template["ENV"].type
  value = var.js30_parameters_template["ENV"].value
}

resource "aws_ssm_parameter" "full_domain_dev" {
  name  = "${var.parameter_store_prefix}dev/${var.parameter_store_app_prefix}${var.js30_parameters_template["FULL_DOMAIN"].name}"
  type  = var.js30_parameters_template["FULL_DOMAIN"].type
  value = var.js30_parameters_template["FULL_DOMAIN"].value
}

resource "aws_ssm_parameter" "api_gw_url_dev" {
  name  = "${var.parameter_store_prefix}dev/${var.parameter_store_app_prefix}${var.js30_parameters_template["API_GW_URL"].name}"
  type  = var.js30_parameters_template["API_GW_URL"].type
  value = replace(local.api_gw_url_dev, "/{basePath}", "")
}

resource "aws_ssm_parameter" "auth_header_dev" {
  name  = "${var.parameter_store_prefix}dev/${var.parameter_store_app_prefix}${var.js30_parameters_template["AUTH_HEADER"].name}"
  type  = var.js30_parameters_template["AUTH_HEADER"].type
  value = "X-API-Key"
}

resource "aws_ssm_parameter" "auth_token_dev" {
  name  = "${var.parameter_store_prefix}dev/${var.parameter_store_app_prefix}${var.js30_parameters_template["AUTH_TOKEN"].name}"
  type  = var.js30_parameters_template["AUTH_TOKEN"].type
  value = aws_api_gateway_usage_plan_key.api_gw_test_ddb_usageplan_key.value
}

resource "aws_ssm_parameter" "cache_control_dev" {
  name  = "${var.parameter_store_prefix}dev/${var.parameter_store_app_prefix}${var.js30_parameters_template["CACHE_CONTROL"].name}"
  type  = var.js30_parameters_template["CACHE_CONTROL"].type
  value = var.js30_parameters_template["CACHE_CONTROL"].value
}

#############################################################

resource "aws_ssm_parameter" "app_name_dev" {
  name  = "${var.parameter_store_prefix}dev/${var.parameter_store_app_prefix}${var.js30_parameters_template["APP_NAME"].name}"
  type  = var.js30_parameters_template["APP_NAME"].type
  value = var.js30_parameters_template["APP_NAME"].value
}

resource "aws_ssm_parameter" "idp_url_dev" {
  name  = "${var.parameter_store_prefix}dev/${var.parameter_store_app_prefix}${var.js30_parameters_template["IDP_URL"].name}"
  type  = var.js30_parameters_template["IDP_URL"].type
  value = var.js30_parameters_template["IDP_URL"].value
}

resource "aws_ssm_parameter" "idp_client_id_dev" {
  name  = "${var.parameter_store_prefix}dev/${var.parameter_store_app_prefix}${var.js30_parameters_template["IDP_CLIENT_ID"].name}"
  type  = var.js30_parameters_template["IDP_CLIENT_ID"].type
  value = aws_cognito_user_pool_client.user_pool_client_dev.id
}


resource "aws_ssm_parameter" "auth_url_dev" {
  name  = "${var.parameter_store_prefix}dev/${var.parameter_store_app_prefix}${var.js30_parameters_template["AUTHORIZER_URL"].name}"
  type  = var.js30_parameters_template["AUTHORIZER_URL"].type
  value = aws_cognito_user_pool.user_pool_dev.domain
}
