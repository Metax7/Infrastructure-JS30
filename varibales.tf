variable "aws_profile" {
  type        = string
  sensitive   = true
  description = "AWS Access Credentials"
}
variable "default_region" {
  type        = string
  default     = "us-east-2"
  description = "default region of master account"
}
variable "default_tag_created_by" {
  type    = string
  default = "Terraform"
}
variable "default_tag_environment" {
  type    = string
  default = "Prod-foundational-infra"
}
variable "default_org_tag" {
  type    = string
  default = "Car-Rental"
}
