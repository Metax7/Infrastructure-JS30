# __generated__ by Terraform
# Please review these resources and move them into your main configuration files.

# __generated__ by Terraform from "xycuoe"
resource "aws_api_gateway_usage_plan" "api_gw_test_ddb_usageplan" {
  description  = "Created by AWS Lambda"
  name         = "testDynamoDBFullIntegration-UsagePlan"
  product_code = null
  tags         = {}
  tags_all     = {}
  api_stages {
    api_id = "inkjvqc8s8"
    stage  = "dev"
  }
  quota_settings {
    limit  = 1000
    offset = 0
    period = "DAY"
  }
  throttle_settings {
    burst_limit = 5
    rate_limit  = 5
  }
}

# __generated__ by Terraform
resource "aws_api_gateway_rest_api" "api_gw_dev" {
  api_key_source               = "HEADER"
  binary_media_types           = []
  body                         = null
  description                  = "js30api creared manually"
  disable_execute_api_endpoint = false
  fail_on_warnings             = null
  minimum_compression_size     = null
  name                         = "js30m"
  parameters                   = null
  policy                       = null
  put_rest_api_mode            = "overwrite"
  tags                         = {}
  tags_all                     = {}
  endpoint_configuration {
    types = ["REGIONAL"]

  }
}

# __generated__ by Terraform from "xycuoe/snospw72gk"
resource "aws_api_gateway_usage_plan_key" "api_gw_test_ddb_usageplan_key" {
  key_id        = "snospw72gk"
  key_type      = "API_KEY"
  usage_plan_id = "xycuoe"
}
