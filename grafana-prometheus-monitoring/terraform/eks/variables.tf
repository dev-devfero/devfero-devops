
variable "aws_region" { type = string default = "us-east-1" }
variable "cluster_name" { type = string }
variable "oidc_provider_arn" { type = string }
variable "external_secrets_namespace" { type = string default = "external-secrets" }
variable "service_account_name" { type = string default = "external-secrets-sa" }
