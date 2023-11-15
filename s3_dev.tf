resource "aws_s3_bucket_website_configuration" "website_dev" {
  bucket = aws_s3_bucket.website_bucket_dev.id
  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket" "website_bucket_dev" {
  bucket = "dev.metax7.my-best-code.com"

  lifecycle {
    prevent_destroy = true
  }
  tags = {
    CreatedBy   = "terraform"
    Environment = "dev"
    Account     = "sandbox"
    TargetUser  = "Metax7"
    Owner       = "Dmitri Konnov"
  }
}

resource "aws_s3_bucket_public_access_block" "public_access_full_allow_dev" {
  bucket                  = aws_s3_bucket.website_bucket_dev.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_server_side_encryption_configuration" "website_encryption_config_dev" {
  bucket = aws_s3_bucket.website_bucket_dev.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_policy" "website_dev_bucket_policy" {
  bucket = aws_s3_bucket.website_bucket_dev.id
  policy = data.aws_iam_policy_document.web_site_allow_all_policy_dev.json
}

data "aws_iam_policy_document" "web_site_allow_all_policy_dev" {
  statement {
    sid    = "AllowGetData"
    effect = "Allow"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.website_bucket_dev.arn}/*"]
  }
}

data "aws_route53_zone" "metax7_hosted_zone" {
  name         = "metax7.my-best-code.com"
  private_zone = false
}


resource "aws_route53_record" "dev_metax7_my-best-code_com-a-record" {
  name    = "dev.metax7.my-best-code.com"
  type    = "A"
  zone_id = data.aws_route53_zone.metax7_hosted_zone.zone_id

  alias {
    name                   = aws_s3_bucket_website_configuration.website_dev.website_endpoint
    zone_id                = aws_s3_bucket.website_bucket_dev.hosted_zone_id
    evaluate_target_health = false
  }
}
