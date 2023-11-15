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
