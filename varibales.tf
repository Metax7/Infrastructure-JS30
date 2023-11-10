variable "aws_profile" {
  type        = string
  sensitive   = true
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
