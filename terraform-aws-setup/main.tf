
module "network" {
  source         = "./modules/network"
  project_prefix = var.project_prefix
  aws_region     = var.aws_region
}

module "iam" {
  source         = "./modules/iam"
  project_prefix = var.project_prefix
}

module "secrets" {
  source         = "./modules/secrets"
  project_prefix = var.project_prefix
}

module "ecr" {
  source         = "./modules/ecr"
  project_prefix = var.project_prefix
}

module "ecs" {
  source             = "./modules/ecs"
  project_prefix     = var.project_prefix
  vpc_id             = module.network.vpc_id
  private_subnets    = module.network.private_subnets
  public_subnets     = module.network.public_subnets
  alb_sg_id          = module.network.alb_sg_id
  ecs_sg_id          = module.network.ecs_sg_id
  ecr_repo_url       = module.ecr.repository_url
  task_role_arn      = module.iam.task_role_arn
  execution_role_arn = module.iam.execution_role_arn
  secret_arn         = module.secrets.secret_arn
  aws_region         = var.aws_region
}
