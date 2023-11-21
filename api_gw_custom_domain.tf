resource "aws_api_gateway_domain_name" "regional_endpoint" {
  domain_name              = "${var.regional_api_domain_prefix}${var.metax7_full_domain}"
  regional_certificate_arn = aws_acm_certificate_validation.cert_for_us-west-1.certificate_arn

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}


resource "aws_route53_record" "regional_endpoint_a-record" {
  name    = aws_api_gateway_domain_name.regional_endpoint.domain_name
  type    = "A"
  zone_id = data.aws_route53_zone.metax7_hosted_zone.id

  alias {
    evaluate_target_health = false
    name                   = aws_api_gateway_domain_name.regional_endpoint.regional_domain_name
    zone_id                = aws_api_gateway_domain_name.regional_endpoint.regional_zone_id
  }
}

resource "aws_api_gateway_base_path_mapping" "regional_endpoint_mapping" {
  api_id      = aws_api_gateway_rest_api.api_gw_dev.id
  domain_name = aws_api_gateway_domain_name.regional_endpoint.domain_name
}


# The workflow below requests an managed TLS-Cert from ACM, creates appropriate CNAME record and validates the issued certificate.

resource "aws_acm_certificate" "cert_for_us-west-1" {
  domain_name       = "*.${var.metax7_full_domain}"
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "cert_for_us-west-1_cname-records" {
  for_each = {
    for dvo in aws_acm_certificate.cert_for_us-west-1.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 300
  type            = each.value.type
  zone_id         = data.aws_route53_zone.metax7_hosted_zone.zone_id
}

resource "aws_acm_certificate_validation" "cert_for_us-west-1" {
  certificate_arn         = aws_acm_certificate.cert_for_us-west-1.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_for_us-west-1_cname-records : record.fqdn]
  timeouts {
    create = "10m"
  }
}
