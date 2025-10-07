
module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "${var.project_prefix}-eks-cluster"
  cluster_version = "1.28"
  subnets         = ["subnet-xxxxxx", "subnet-yyyyyy"]  # replace with your subnet IDs
  vpc_id          = "vpc-xxxxxx"  # replace with your VPC ID

  node_groups = {
    demo_nodes = {
      desired_capacity = 2
      max_capacity     = 3
      min_capacity     = 1
      instance_type    = "t3.medium"
    }
  }
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  token                  = module.eks.cluster_auth_token
}
