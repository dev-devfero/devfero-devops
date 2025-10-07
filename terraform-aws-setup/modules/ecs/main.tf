
resource "aws_ecs_cluster" "this" {
  name = "${var.project_prefix}-ecs-cluster"
}

resource "aws_lb" "alb" {
  name = "${var.project_prefix}-alb"
  internal = false
  load_balancer_type = "application"
  security_groups = [var.alb_sg_id]
  subnets = var.public_subnets
}

resource "aws_lb_target_group" "tg" {
  name = "${var.project_prefix}-tg"
  port = 5000
  protocol = "HTTP"
  vpc_id = var.vpc_id
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port = "80"
  protocol = "HTTP"
  default_action { type = "forward" target_group_arn = aws_lb_target_group.tg.arn }
}

resource "aws_cloudwatch_log_group" "ecs" {
  name = "/ecs/${var.project_prefix}"
}

resource "aws_ecs_task_definition" "app" {
  family = "${var.project_prefix}-task"
  network_mode = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu = "512"
  memory = "1024"
  execution_role_arn = var.execution_role_arn
  task_role_arn = var.task_role_arn

  container_definitions = jsonencode([{
    name = "app"
    image = "${var.ecr_repo_url}:latest"
    portMappings = [{ containerPort = 5000, protocol = "tcp" }]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group = "/ecs/${var.project_prefix}"
        awslogs-region = var.aws_region
        awslogs-stream-prefix = "ecs"
      }
    }
    secrets = [{
      name = "DB_PASSWORD"
      valueFrom = var.secret_arn
    }]
  }])
}

resource "aws_ecs_service" "app" {
  name = "${var.project_prefix}-service"
  cluster = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count = 1
  launch_type = "FARGATE"
  network_configuration {
    subnets = var.private_subnets
    security_groups = [var.ecs_sg_id]
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.tg.arn
    container_name = "app"
    container_port = 5000
  }
  depends_on = [aws_lb_listener.http]
}
