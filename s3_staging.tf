# resource "aws_s3_bucket_website_configuration" "website_staging" {
#   bucket = aws_s3_bucket.website_bucket_staging.id
#   index_document {
#     suffix = "index.html"
#   }
# }

# resource "aws_s3_bucket" "website_bucket_staging" {
#   bucket = "staging.metax7.my-best-code.com"

#   lifecycle {
#     prevent_destroy = true
#   }
#   tags = {
#     CreatedBy   = "terraform"
#     Environment = "staging"
#     Account     = "sandbox"
#     TargetUser  = "Metax7"
#     Owner       = "Dmitri Konnov"
#   }
# }

# resource "aws_s3_bucket_public_access_block" "public_access_full_allow_staging" {
#   bucket                  = aws_s3_bucket.website_bucket_staging.id
#   block_public_acls       = false
#   block_public_policy     = false
#   ignore_public_acls      = false
#   restrict_public_buckets = false
# }

# resource "aws_s3_bucket_server_side_encryption_configuration" "website_encryption_config_staging" {
#   bucket = aws_s3_bucket.website_bucket_staging.id

#   rule {
#     apply_server_side_encryption_by_default {
#       sse_algorithm = "AES256"
#     }
#   }
# }

# resource "aws_s3_bucket_policy" "website_staging_bucket_policy" {
#   bucket = aws_s3_bucket.website_bucket_staging.id
#   policy = data.aws_iam_policy_document.web_site_allow_cfn_staging.json
# }

# data "aws_iam_policy_document" "web_site_allow_cfn_staging" {

# }
