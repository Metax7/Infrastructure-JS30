variable "aws_profile" {
  type        = string
  sensitive   = true
  default     = "metax-sandbox-adm"
  description = "AWS Access Credentials"
}
variable "default_region" {
  type        = string
  default     = "us-west-1"
  description = "default region"
}
variable "default_tag_created_by" {
  type    = string
  default = "Terraform"
}
variable "default_tag_environment" {
  type    = string
  default = "sandbox"
}
variable "default_org_tag" {
  type    = string
  default = "my-best-code"
}

variable "number_of_likeable_items" {
  type     = number
  default  = 30
  nullable = false
}

variable "js30_parameters" {
  type = map(list(object({
    name        = string
    type        = string
    value       = string
    description = string
  })))
  default = {
    dev = [{
      name        = "CF_DISTR_ID"
      type        = "String"
      value       = ""
      description = "AWS CloudFront Distribution Id"
      },
      {
        name        = "FULL_DOMAIN"
        type        = "String"
        value       = ""
        description = "AWS FULL DOMAIN name used as S3 Bucket name for static hosting"
      },
      {
        name        = "ENV"
        type        = "String"
        value       = "dev"
        description = "Environment the appliaction operates in"
      },
      {
        name        = "AUTH_HEADER"
        type        = "String"
        value       = ""
        description = "Header added to authorized requests"
      },
      {
        name        = "AUTH_TOKEN"
        type        = "String"
        value       = ""
        description = "Token used for authorized requests"
      },
      {
        name        = "APP_NAME"
        type        = "String"
        value       = ""
        description = "Application Name used against Oauth2 Infrastructure"
      },
      {
        name        = "IDP_URL"
        type        = "String"
        value       = ""
        description = "Identity Provider Url"
      },
      {
        name        = "AUTHORIZER_URL"
        type        = "String"
        value       = ""
        description = "Authorizer Url"
      },
      {
        name        = "CACHE_CONTROL"
        type        = "String"
        value       = "max-age=60, s-maxage=86400"
        description = "Cache-Control settings applied one or multiple files in the bucket"
      }
    ],
    prod = [{
      name        = "CF_DISTR_ID"
      type        = "String"
      value       = ""
      description = "AWS CloudFront Distribution Id"
      },
      {
        name        = "FULL_DOMAIN"
        type        = "String"
        value       = ""
        description = "AWS FULL DOMAIN name used as S3 Bucket name for static hosting"
      },
      {
        name        = "ENV"
        type        = "String"
        value       = "prd"
        description = "Environment the appliaction operates in"
      },
      {
        name        = "AUTH_HEADER"
        type        = "String"
        value       = ""
        description = "Header added to authorized requests"
      },
      {
        name        = "AUTH_TOKEN"
        type        = "String"
        value       = ""
        description = "Token used for authorized requests"
      },
      {
        name        = "APP_NAME"
        type        = "String"
        value       = ""
        description = "Application Name used against Oauth2 Infrastructure"
      },
      {
        name        = "IDP_URL"
        type        = "String"
        value       = ""
        description = "Identity Provider Url"
      },
      {
        name        = "AUTHORIZER_URL"
        type        = "String"
        value       = ""
        description = "Authorizer Url"
      },
      {
        name        = "CACHE_CONTROL"
        type        = "String"
        value       = "max-age=60, s-maxage=86400"
        description = "Cache-Control settings applied one or multiple files in the bucket"
      }
    ],
    statig = [{
      name        = "CF_DISTR_ID"
      type        = "String"
      value       = ""
      description = "AWS CloudFront Distribution Id"
      },
      {
        name        = "FULL_DOMAIN"
        type        = "String"
        value       = ""
        description = "AWS FULL DOMAIN name used as S3 Bucket name for static hosting"
      },
      {
        name        = "ENV"
        type        = "String"
        value       = "staging"
        description = "Environment the appliaction operates in"
      },
      {
        name        = "AUTH_HEADER"
        type        = "String"
        value       = ""
        description = "Header added to authorized requests"
      },
      {
        name        = "AUTH_TOKEN"
        type        = "String"
        value       = ""
        description = "Token used for authorized requests"
      },
      {
        name        = "APP_NAME"
        type        = "String"
        value       = ""
        description = "Application Name used against Oauth2 Infrastructure"
      },
      {
        name        = "IDP_URL"
        type        = "String"
        value       = ""
        description = "Identity Provider Url"
      },
      {
        name        = "AUTHORIZER_URL"
        type        = "String"
        value       = ""
        description = "Authorizer Url"
      },
      {
        name        = "CACHE_CONTROL"
        type        = "String"
        value       = "max-age=60, s-maxage=86400"
        description = "Cache-Control settings applied one or multiple files in the bucket"
      }
    ]
  }
}

variable "parameter_store_prefix" {
  type     = string
  default  = "/sandbox/metax7/js30/"
  nullable = false
}

variable "parameter_store_app_prefix" {
  type     = string
  default  = "JS30_"
  nullable = false
}
variable "environments" {
  type    = list(string)
  default = ["prod", "staging", "dev"]
}
variable "application_env_vars" {
  type = list(string)
  default = [
    "CF_DISTR_ID",
    "FULL_DOMAIN",
    "ENV", "AUTH_HEADER",
    "AUTH_TOKEN",
    "API_GW_URL",
    "APP_NAME",
    "IDP_URL",
    "AUTHORIZER_URL",
  "CACHE_CONTROL"]
  description = "environment variables used for application deployment and required infrastructure"
}
variable "api_gw_name_dev" {
  type = string
}

variable "s3_prod_bucket_full_arn" {
  type      = string
  sensitive = true
}

variable "cloudfront_distro_id_pod" {
  type      = string
  sensitive = false
}

variable "cloudfront_cache_policy_id" {
  type      = string
  sensitive = false
}

variable "origin_access_control_id" {
  type      = string
  sensitive = false

}

variable "api_gw_dev_id" {
  type      = string
  sensitive = false

}

variable "api_gw_usage_plan_id_dev" {
  type      = string
  sensitive = false

}
variable "api_gw_usage_plan_key_dev" {
  type      = string
  sensitive = false
}
