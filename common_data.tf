#########################################################################################################################
# Here are resource references which have been created from master account:
# https://github.com/DmitriKonnovNN/MY-BEST-CODE-COM/tree/master/SDLC_ACCOUNTS/infra/sandbox-metax7
#########################################################################################################################

data "aws_api_gateway_rest_api" "api_dev" {
  name = var.api_gw_name_dev
}
data "aws_route53_zone" "metax7_hosted_zone" {
  name         = "metax7.my-best-code.com"
  private_zone = false
}
# data "dns_cname_record_set" "cname_staging" {
#   host = "staging.metax7.my-best-code.com"
# }

data "aws_api_gateway_export" "api_gw_dev_export" {
  rest_api_id = aws_api_gateway_rest_api.api_gw_dev.id
  stage_name  = "dev"
  export_type = "oas30"
}

output "api_gw_url_dev" {
  value = local.api_gw_url_dev
}

locals {
  api_gw_url_dev = jsondecode(data.aws_api_gateway_export.api_gw_dev_export.body).servers[0]["url"]
}

