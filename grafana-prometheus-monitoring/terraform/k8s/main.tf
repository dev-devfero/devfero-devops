
terraform {
  required_providers {
    aws = { source = "hashicorp/aws" }
    kubernetes = { source = "hashicorp/kubernetes" }
  }
}
provider "aws" { region = var.aws_region }
provider "kubernetes" {}
data "aws_secretsmanager_secret_version" "grafana_admin" { secret_id = var.secret_grafana_admin }
resource "kubernetes_secret" "grafana" {
  metadata { name = "grafana-k8s-secret" namespace = var.k8s_namespace }
  data = {
    username = jsondecode(data.aws_secretsmanager_secret_version.grafana_admin.secret_string).username
    password = jsondecode(data.aws_secretsmanager_secret_version.grafana_admin.secret_string).password
  }
  type = "Opaque"
}
