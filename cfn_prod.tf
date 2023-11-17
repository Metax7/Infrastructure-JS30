# __generated__ by Terraform
# Please review these resources and move them into your main configuration files.

# __generated__ by Terraform from "658327ea-f89d-4fab-a63d-7e88639e58f6"
resource "aws_cloudfront_cache_policy" "policy" {
  comment     = "Policy with caching enabled. Supports Gzip and Brotli compression."
  default_ttl = 86400
  max_ttl     = 31536000
  min_ttl     = 1
  name        = "Managed-CachingOptimized"
  parameters_in_cache_key_and_forwarded_to_origin {
    enable_accept_encoding_brotli = true
    enable_accept_encoding_gzip   = true
    cookies_config {
      cookie_behavior = "none"
    }
    headers_config {
      header_behavior = "none"
    }
    query_strings_config {
      query_string_behavior = "none"
    }
  }
}

# __generated__ by Terraform from "E18OEWTISUYOCJ"
resource "aws_cloudfront_distribution" "distribution" {
  aliases             = ["js30.metax7.my-best-code.com"]
  comment             = null
  default_root_object = "index.html"
  enabled             = true
  http_version        = "http2"
  is_ipv6_enabled     = true
  price_class         = "PriceClass_All"
  retain_on_delete    = false
  tags                = {}
  tags_all = {
    CreatedVia   = "Terraform"
    Environment  = "sandbox"
    Organization = "my-best-code"
  }
  wait_for_deployment = true
  web_acl_id          = null
  custom_error_response {
    error_caching_min_ttl = 0
    error_code            = 403
    response_code         = 200
    response_page_path    = "/index.html"
  }
  default_cache_behavior {
    allowed_methods            = ["GET", "HEAD"]
    cache_policy_id            = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    cached_methods             = ["GET", "HEAD"]
    compress                   = true
    default_ttl                = 0
    field_level_encryption_id  = null
    max_ttl                    = 0
    min_ttl                    = 0
    origin_request_policy_id   = null
    realtime_log_config_arn    = null
    response_headers_policy_id = null
    smooth_streaming           = false
    target_origin_id           = "js30.metax7.my-best-code.com.s3.us-west-1.amazonaws.com"
    trusted_key_groups         = []
    trusted_signers            = []
    viewer_protocol_policy     = "redirect-to-https"
  }
  origin {
    connection_attempts      = 3
    connection_timeout       = 10
    domain_name              = "js30.metax7.my-best-code.com.s3.us-west-1.amazonaws.com"
    origin_access_control_id = "E3MC3VKLKXGPCV"
    origin_id                = "js30.metax7.my-best-code.com.s3.us-west-1.amazonaws.com"
    origin_path              = null
  }
  restrictions {
    geo_restriction {
      locations        = []
      restriction_type = "none"
    }
  }
  viewer_certificate {
    acm_certificate_arn            = "arn:aws:acm:us-east-1:021427789578:certificate/ac593d0d-75c5-43e8-a618-f42d8f01e36c"
    cloudfront_default_certificate = false
    iam_certificate_id             = null
    minimum_protocol_version       = "TLSv1.2_2021"
    ssl_support_method             = "sni-only"
  }
}

# __generated__ by Terraform from "E3MC3VKLKXGPCV"
resource "aws_cloudfront_origin_access_control" "policy" {
  description                       = "Managed by Terraform"
  name                              = "js30.metax7.my-best-code.com.s3.us-west-1.amazonaws.com"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}
