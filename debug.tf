output "hosted_zone_id" {
  value = data.aws_route53_zone.metax7_hosted_zone.id
}
output "bucket_hosted_zone" {
  value = aws_s3_bucket.website_bucket_dev.hosted_zone_id
}

output "website_endpoint" {
  value = aws_s3_bucket_website_configuration.website_dev.website_endpoint
}
output "website_domain" {
  value = aws_s3_bucket_website_configuration.website_dev.website_domain
}
output "api_gw_dev" {
  value = data.aws_api_gateway_rest_api.api_dev
}
