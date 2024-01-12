# __generated__ by Terraform
# Please review these resources and move them into your main configuration files.

# __generated__ by Terraform from "us-west-1_DMqCcn38p/1rq65aa262uk8bmvbunb8fqg31"
resource "aws_cognito_user_pool_client" "user_pool_client_dev" {
  access_token_validity                         = 60
  allowed_oauth_flows                           = ["code"]
  allowed_oauth_flows_user_pool_client          = true
  allowed_oauth_scopes                          = ["aws.cognito.signin.user.admin", "email", "https://www.googleapis.com/auth/photoslibrary/photoslibrary.readonly", "openid", "profile"]
  auth_session_validity                         = 3
  callback_urls                                 = ["http://localhost:5173", "https://dev.${var.metax7_full_domain}"]
  default_redirect_uri                          = null
  enable_propagate_additional_user_context_data = false
  enable_token_revocation                       = true
  explicit_auth_flows                           = ["ALLOW_REFRESH_TOKEN_AUTH", "ALLOW_USER_SRP_AUTH"]
  generate_secret                               = null
  id_token_validity                             = 60
  logout_urls                                   = []
  name                                          = "JS30LOCAL_DEV_WFI"
  prevent_user_existence_errors                 = "ENABLED"
  read_attributes                               = ["address", "birthdate", "custom:google_refresh_token", "email", "email_verified", "family_name", "gender", "given_name", "locale", "middle_name", "name", "nickname", "phone_number", "phone_number_verified", "picture", "preferred_username", "profile", "updated_at", "website", "zoneinfo"]
  refresh_token_validity                        = 30
  supported_identity_providers                  = ["COGNITO", "Google"]
  user_pool_id                                  = aws_cognito_user_pool.user_pool_dev.id
  write_attributes                              = ["address", "birthdate", "custom:google_refresh_token", "email", "family_name", "gender", "given_name", "locale", "middle_name", "name", "nickname", "phone_number", "picture", "preferred_username", "profile", "updated_at", "website", "zoneinfo"]
  token_validity_units {
    access_token  = "minutes"
    id_token      = "minutes"
    refresh_token = "days"
  }
}

# __generated__ by Terraform from "us-west-1_DMqCcn38p"
resource "aws_cognito_user_pool" "user_pool_dev" {
  alias_attributes           = null
  auto_verified_attributes   = ["email"]
  deletion_protection        = "ACTIVE"
  email_verification_message = null
  email_verification_subject = null
  mfa_configuration          = "OFF"
  name                       = "JS30LOCALDEV_WFI"
  sms_authentication_message = null
  sms_verification_message   = null
  tags                       = {}
  tags_all = {
    CreatedVia   = "Terraform"
    Environment  = "sandbox"
    Organization = "my-best-code"
  }
  username_attributes = ["email"]
  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
  }
  admin_create_user_config {
    allow_admin_create_user_only = false
  }
  email_configuration {
    configuration_set      = null
    email_sending_account  = "COGNITO_DEFAULT"
    from_email_address     = null
    reply_to_email_address = "dmitri.v.konnov@gmail.com"
    source_arn             = null
  }
  lambda_config {
    create_auth_challenge          = null
    custom_message                 = null
    define_auth_challenge          = null
    kms_key_id                     = null
    post_authentication            = null
    post_confirmation              = aws_lambda_function.postSignUpConfirmationV2.arn
    pre_authentication             = null
    pre_sign_up                    = null
    pre_token_generation           = null
    user_migration                 = null
    verify_auth_challenge_response = null
  }
  password_policy {
    minimum_length                   = 8
    require_lowercase                = true
    require_numbers                  = true
    require_symbols                  = true
    require_uppercase                = true
    temporary_password_validity_days = 7
  }
  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = false
    name                     = "gat"
    required                 = false
    string_attribute_constraints {
      max_length = null
      min_length = null
    }
  }
  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "email"
    required                 = true
    string_attribute_constraints {
      max_length = "2048"
      min_length = "0"
    }
  }
  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "google_access_token"
    required                 = false
    string_attribute_constraints {
      max_length = null
      min_length = null
    }
  }
  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "google_refresh_token"
    required                 = false
    string_attribute_constraints {
      max_length = null
      min_length = null
    }
  }
  user_attribute_update_settings {
    attributes_require_verification_before_update = ["email"]
  }
  username_configuration {
    case_sensitive = false
  }
  verification_message_template {
    default_email_option  = "CONFIRM_WITH_CODE"
    email_message         = null
    email_message_by_link = null
    email_subject         = null
    email_subject_by_link = null
    sms_message           = null
  }
}
