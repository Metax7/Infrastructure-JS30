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
resource "aws_ssm_parameter" "google_scope_dev" {
  name  = "${var.parameter_store_prefix}dev/${var.parameter_store_app_prefix}${var.js30_parameters_template["GOOGLE_SCOPE"].name}"
  type  = var.js30_parameters_template["GOOGLE_SCOPE"].type
  value = var.js30_parameters_template["GOOGLE_SCOPE"].value
}
resource "aws_ssm_parameter" "google_client_id_dev" {
  name  = "${var.parameter_store_prefix}dev/${var.parameter_store_app_prefix}${var.js30_parameters_template["GOOGLE_CLIENT_ID"].name}"
  type  = var.js30_parameters_template["GOOGLE_CLIENT_ID"].type
  value = var.google_client_id_dev
}

resource "aws_ssm_parameter" "google_client_secret_dev" {
  name  = "${var.parameter_store_prefix}dev/${var.parameter_store_app_prefix}${var.js30_parameters_template["GOOGLE_CLIENT_SECRET"].name}"
  type  = var.js30_parameters_template["GOOGLE_CLIENT_SECRET"].type
  value = var.google_client_secret_dev
}


resource "aws_ssm_parameter" "init_refresh_token_cipher_key_dev" {
  name  = local.rtckc_name
  type  = var.js30_parameters_template["INIT_REFRESH_TOKEN_CIPHER_KEY"].type
  value = "INIT_VAL" // can be anything since its replace by provisioner
  tier  = "Advanced"

  lifecycle {
    ignore_changes = [value]
  }

  provisioner "local-exec" {
    command = templatefile("${var.scripts_dir}/update-ssm-expiration-policy.sh.tpl", {
      NAME     = local.rtckc_name,
      VALUE    = local.rtckc_initval,
      POLICIES = local.rtckc_policy,
      PROFILE  = var.aws_profile
    })

    on_failure  = fail
    interpreter = ["bash", "-c"]

  }
  # The provisoners down below didn't work as policy array couldn't be mapped properly to a var in bash script. Revision needed.
  #    provisioner "local-exec" {
  #      command     = "sh ${var.scripts_dir}/update-ssm-expiration-policy.sh -n ${local.rtckc_name} -v ${local.rtckc_initval} -a ${var.aws_profile} -p ${jsonencode(local.rtckc_policy)} "
  #      on_failure  = fail
  #     interpreter = ["bash", "-c"]
  #    }

  #  provisioner "local-exec" {
  #    command     = <<-EOF
  #    sh ${var.scripts_dir}/update-ssm-expiration-policy.sh \
  #      -n "${local.rtckc_name}" \
  #      -v "${local.rtckc_initval}" \
  #      -a "${var.aws_profile}" \
  #      -p ${local.rtckc_policy}
  #  EOF
  #    interpreter = ["bash", "-c"]
  #    on_failure  = fail
  #  }


}

resource "null_resource" "set_no_change_notification_period" {

  provisioner "local-exec" {
    command = local.is_resetting_policy_locked ? "echo -e '${var.NOT_TRIGGED_MSG}'" : templatefile("${var.scripts_dir}/update-ssm-expiration-policy.sh.tpl", {
      NAME     = local.rtckc_name,
      VALUE    = local.rtckc_initval,
      POLICIES = local.rtckc_policy,
      PROFILE  = var.aws_profile
    })
    on_failure  = fail
    interpreter = ["bash", "-c"]
  }

  triggers = {
    policy_change = local.rtckc_policy
    exec_lock     = local.is_resetting_policy_locked
  }
}


data "external" "init_cipherkey_dev" {
  program = [
    "bash", "${var.scripts_dir}/generateInitCipherkey.sh",
  ]
  query = {
    size   = 32
    encode = "base64"
  }
}

locals {
  rtckc_name = "${var.parameter_store_prefix}dev/${var.parameter_store_app_prefix}${var.js30_parameters_template["INIT_REFRESH_TOKEN_CIPHER_KEY"].name}"
  //rtckc_expiration_time = timeadd(timestamp(), "24h")
  rtckc_initval              = data.external.init_cipherkey_dev.result.cipherkey
  rtckc_policy               = jsonencode(templatefile("${var.templates_dir}/ssm_param_NoChangeNotification_policy.tftpl", { AFTER = 8, UNITS = "Hours" }))
  is_resetting_policy_locked = false

}



