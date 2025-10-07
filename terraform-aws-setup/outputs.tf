
output "alb_dns" {
  value = module.ecs.alb_dns
}

output "ecr_repository_url" {
  value = module.ecr.repository_url
}

output "ecs_cluster_name" {
  value = module.ecs.cluster_name
}

output "vpc_id" {
  value = module.network.vpc_id
}
