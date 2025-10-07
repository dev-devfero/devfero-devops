
variable "project_prefix" { type = string }
variable "vpc_id" { type = string }
variable "public_subnets" { type = list(string) }
variable "private_subnets" { type = list(string) }
variable "alb_sg_id" { type = string }
variable "ecs_sg_id" { type = string }
variable "ecr_repo_url" { type = string }
variable "task_role_arn" { type = string }
variable "execution_role_arn" { type = string }
variable "secret_arn" { type = string }
variable "aws_region" { type = string }
