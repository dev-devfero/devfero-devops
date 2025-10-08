
terraform {
  required_providers {
    aws = { source = "hashicorp/aws" }
  }
}
provider "aws" { region = var.aws_region }
data "aws_iam_openid_connect_provider" "oidc" {
  arn = var.oidc_provider_arn
}
data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    effect = "Allow"
    principals { type = "Federated" identifiers = [data.aws_iam_openid_connect_provider.oidc.arn] }
    condition {
      test = "StringEquals"
      variable = "${replace(data.aws_iam_openid_connect_provider.oidc.url, "https://", "")}:sub"
      values = ["system:serviceaccount:${var.external_secrets_namespace}:${var.service_account_name}"]
    }
    actions = ["sts:AssumeRoleWithWebIdentity"]
  }
}
resource "aws_iam_role" "external_secrets_role" {
  name = "external-secrets-role-${var.cluster_name}"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}
resource "aws_iam_policy" "secrets_read" {
  name = "external-secrets-secrets-read-${var.cluster_name}"
  policy = jsonencode({Version="2012-10-17",Statement=[{Effect="Allow",Action=["secretsmanager:GetSecretValue"],Resource=["*"]}] })
}
resource "aws_iam_role_policy_attachment" "attach" {
  role = aws_iam_role.external_secrets_role.name
  policy_arn = aws_iam_policy.secrets_read.arn
}
output "role_arn" { value = aws_iam_role.external_secrets_role.arn }
