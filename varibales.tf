variable "aws_profile" {
  type        = string
  sensitive   = false
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
    },
    GOOGLE_SCOPE = {
      name        = "GOOGLE_SCOPE"
      type        = "String"
      value       = "aws.cognito.signin.user.admin email openid profile https://www.googleapis.com/auth/photoslibrary.readonly"
      description = "OAuth2 Scope for Google IdP and it's APIs"
    },
    GOOGLE_CLIENT_ID = {
      name        = "GOOGLE_CLIENT_ID"
      type        = "SecureString"
      value       = "NONE"
      description = "Cognito's client id assigned by Google OAuth2 (Google Client)"
    },
    GOOGLE_CLIENT_SECRET = {
      name        = "GOOGLE_CLIENT_SECRET"
      type        = "SecureString"
      value       = "NONE"
      description = "Cognito's client secret assigned by Google OAuth2 (Google Client Secret)"
    },
    INIT_REFRESH_TOKEN_CIPHER_KEY = {
      name        = "REFRESH_TOKEN_CIPHER_KEY"
      type        = "SecureString"
      value       = "NONE"
      description = "OLNY FOR DEV PURPOSES: Base64 encoded initial client secret to be regenerated and afterwards stored in SecretsManager"
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
    "CACHE_CONTROL",
    "GOOGLE_SCOPE",
    "GOOGLE_CLIENT_ID",
    "GOOGLE_CLIENT_SECRET",
    "REFRESH_TOKEN_CIPHER_KEY"
  ]
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

variable "google_client_id_dev" {
  type      = string
  sensitive = true
  default   = "NONE"
}
variable "google_client_secret_dev" {
  type      = string
  sensitive = true
  default   = "NONE"
}
variable "templates_dir" {
  type    = string
  default = "./templates"
}

variable "scripts_dir" {
  type    = string
  default = "./scripts"
}

variable "lambdas_by_gw_dir" {
  type    = string
  default = "LambdasTriggeredByApiGateway"
}

variable "NOT_TRIGGED_MSG" {
  type    = string
  default = ">>>> \\033[33mEXECUTOR WAS SURPRESSED BY BLOCKING CONDITION\\033[m <<<<"
}
