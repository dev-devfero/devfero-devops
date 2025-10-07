
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "project_prefix" {
  description = "Prefix for naming AWS resources"
  type        = string
  default     = "demo"
}

variable "backend_bucket" {
  type        = string
  description = "Terraform backend S3 bucket"
}

variable "backend_key" {
  type        = string
  description = "Terraform state file key"
  default     = "terraform.tfstate"
}

variable "backend_dynamodb_table" {
  type        = string
  description = "DynamoDB table for state locking"
}
