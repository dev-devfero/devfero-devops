
resource "random_password" "secret" {
  length = 16
  special = true
}

resource "aws_secretsmanager_secret" "app" {
  name = "${var.project_prefix}-app-secret"
}

resource "aws_secretsmanager_secret_version" "v" {
  secret_id = aws_secretsmanager_secret.app.id
  secret_string = jsonencode({ DB_PASSWORD = random_password.secret.result })
}
