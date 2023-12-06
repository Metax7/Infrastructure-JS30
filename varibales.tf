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

variable "js30_parameters_template" {
  type = map(object({
    name        = string
    type        = string
    value       = string
    description = string
  }))
  default = {
    CF_DISTR_ID = {
      name        = "CF_DISTR_ID"
      type        = "String"
      value       = "NONE"
      description = "AWS CloudFront Distribution Id"
    },
    FULL_DOMAIN = {
      name        = "FULL_DOMAIN"
      type        = "String"
      value       = "dev.metax7.my-best-code.com"
      description = "AWS FULL DOMAIN name used as S3 Bucket name for static hosting"
    },
    API_GW_URL = {
      name        = "API_GW_URL"
      type        = "String"
      value       = ""
      description = ""
    },
    ENV = {
      name        = "ENV"
      type        = "String"
      value       = "dev"
      description = "Environment the appliaction operates in"
    },

    AUTH_HEADER = {
      name        = "AUTH_HEADER"
      type        = "String"
      value       = ""
      description = "Header added to authorized requests"
    },
    AUTH_TOKEN = {
      name        = "AUTH_TOKEN"
      type        = "String"
      value       = ""
      description = "Token used for authorized requests"
    },
    APP_NAME = {
      name        = "APP_NAME"
      type        = "String"
      value       = "NONE"
      description = "Application Name used against Oauth2 Infrastructure"
    },
    IDP_URL = {
      name        = "IDP_URL"
      type        = "String"
      value       = "NONE"
      description = "Identity Provider Url"
    },
    IDP_CLIENT_ID = {
      name        = "IDP_CLIENT_ID"
      type        = "String"
      value       = "NONE"
      description = "Authorizer Client ID"
    },

    AUTHORIZER_URL = {
      name        = "AUTHORIZER_URL"
      type        = "String"
      value       = "NONE"
      description = "Authorizer Url"
    },
    CACHE_CONTROL = {
      name        = "CACHE_CONTROL"
      type        = "String"
      value       = "max-age=60, s-maxage=86400"
      description = "Cache-Control settings applied one or multiple files in the bucket"
    }
  }
}

variable "app_prod_full_domain" {
  type    = string
  default = "js30.metax7.my-best-code.com"
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

variable "regional_api_domain_prefix" {
  type    = string
  default = "api-r."
}

variable "edge_optimized_api_domain_prefix" {
  type    = string
  default = "api-eo."
}

variable "metax7_full_domain" {
  type    = string
  default = "metax7.my-best-code.com"
}

variable "cognito_user_pool_id_localdev" {
  type = string
}
variable "cognito_user_pool_client_id_localdev" {
  type = string
}
