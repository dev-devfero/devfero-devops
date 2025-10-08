
terraform {
  required_providers {
    aws = { source = "hashicorp/aws" }
    local = { source = "hashicorp/local" }
  }
}
provider "aws" { region = var.aws_region }
data "aws_secretsmanager_secret_version" "grafana_admin" { secret_id = var.secret_grafana_admin }
resource "local_file" "grafana_admin_user" {
  content  = jsondecode(data.aws_secretsmanager_secret_version.grafana_admin.secret_string).username
  filename = "${path.module}/grafana-admin-user"
}
resource "local_file" "grafana_admin_pass" {
  content  = jsondecode(data.aws_secretsmanager_secret_version.grafana_admin.secret_string).password
  filename = "${path.module}/grafana-admin-password"
}
