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
