terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.5.0"
    }

  }
  backend "s3" {
    bucket         = "mbc-remote-state-metax7-sandbox"
    dynamodb_table = "mbc-remote-state-lock-metax7-sandbox"
    encrypt        = true
    key            = "js30/sandbox/terraform.tfstate"
    region         = "us-west-1"
    profile        = "metax-sandbox-adm"

  }
  required_version = ">= 0.13.1"
}


provider "aws" {


  profile = var.aws_profile
  region  = var.default_region

  default_tags {
    tags = {
      Environment  = var.default_tag_environment
      CreatedVia   = var.default_tag_created_by
      Organization = var.default_org_tag
    }
  }
}

# terraform plan -generate-config-out=s3_prod.tf
import {
  id = "js30.metax7.my-best-code.com"
  to = aws_s3_bucket.web_site_bucket_prod
}

import {
  id = "js30.metax7.my-best-code.com"
  to = aws_s3_bucket_website_configuration.website_prod
}

import {
  to = aws_s3_bucket_policy.website_pod_bucket_policy
  id = "js30.metax7.my-best-code.com"
}

import {
  to = aws_cloudfront_distribution.distribution
  id = var.cloudfront_distro_id_pod
}

import {
  to = aws_cloudfront_cache_policy.policy
  id = var.cloudfront_cache_policy_id
}

import {
  to = aws_cloudfront_origin_access_control.policy
  id = var.origin_access_control_id
}

import {
  to = aws_api_gateway_rest_api.api_gw_dev
  id = var.api_gw_dev_id
}

# import {
#   to = aws_api_gateway_stage.api_gw_stage_dev
#   id = "${var.api_gw_dev_id}/dev"
# }

import {
  to = aws_api_gateway_usage_plan.api_gw_test_ddb_usageplan
  id = var.api_gw_usage_plan_id_dev
}

import {
  to = aws_api_gateway_usage_plan_key.api_gw_test_ddb_usageplan_key
  id = "${var.api_gw_usage_plan_id_dev}/${var.api_gw_usage_plan_key_dev}"
}
