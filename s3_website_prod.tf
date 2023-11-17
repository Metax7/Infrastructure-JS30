# __generated__ by Terraform
# Please review these resources and move them into your main configuration files.

# __generated__ by Terraform from "js30.metax7.my-best-code.com"
resource "aws_s3_bucket_policy" "website_pod_bucket_policy" {
  bucket = "js30.metax7.my-best-code.com"
  policy = "{\"Id\":\"PolicyForCloudFrontPrivateContent\",\"Statement\":[{\"Action\":\"s3:GetObject\",\"Condition\":{\"StringEquals\":{\"AWS:SourceArn\":\"arn:aws:cloudfront::021427789578:distribution/E18OEWTISUYOCJ\"}},\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"cloudfront.amazonaws.com\"},\"Resource\":\"arn:aws:s3:::js30.metax7.my-best-code.com/*\",\"Sid\":\"AllowCloudFrontServicePrincipal\"}],\"Version\":\"2008-10-17\"}"
}

# __generated__ by Terraform from "js30.metax7.my-best-code.com"
resource "aws_s3_bucket_website_configuration" "website_prod" {
  bucket                = "js30.metax7.my-best-code.com"
  expected_bucket_owner = null
  routing_rules         = null
  error_document {
    key = "error.html"
  }
  index_document {
    suffix = "index.html"
  }
}

# __generated__ by Terraform from "js30.metax7.my-best-code.com"
resource "aws_s3_bucket" "web_site_bucket_prod" {
  bucket              = "js30.metax7.my-best-code.com"
  bucket_prefix       = null
  force_destroy       = null
  object_lock_enabled = false
  tags                = {}
  tags_all = {
    CreatedVia   = "Terraform"
    Environment  = "sandbox"
    Organization = "my-best-code"
  }
}
