module "eks" {
  source       = "terraform-aws-modules/eks/aws"
  cluster_name = local.cluster_name
  subnets      = module.vpc.private_subnets
  cluster_version = var.cluster_version
  tags = {
    Environment = "training"
    GithubRepo  = "terraform-aws-eks"
    GithubOrg   = "terraform-aws-modules"
  }

  vpc_id = module.vpc.vpc_id

  node_groups = {
    eks_nodes_1 = {
      desired_capacity = 3
      max_capacity     = 8
      min_capaicty     = 1
      subnet_ids       = module.vpc.private_subnets[0]
      instance_type = var.worker_type
      tags = {
        "kubernetes.io/cluster/${local.cluster_name}/autoscalerenable" = "k8s.io/cluster-autoscaler/enabled"
        "kubernetes.io/cluster/${local.cluster_name}/autoscaler"  = "k8s.io/cluster-autoscaler/${local.cluster_name}"
      }
    }
    eks_nodes_2 = {
      desired_capacity = 3
      max_capacity     = 8
      min_capaicty     = 1
      subnet_ids       = module.vpc.private_subnets[1]
      instance_type = var.worker_type
      tags = {
        "kubernetes.io/cluster/${local.cluster_name}/autoscalerenable" = "k8s.io/cluster-autoscaler/enabled"
        "kubernetes.io/cluster/${local.cluster_name}/autoscaler"  = "k8s.io/cluster-autoscaler/${local.cluster_name}"
      }
    }
    eks_nodes_3 = {
      desired_capacity = 3
      max_capacity     = 8
      min_capaicty     = 1
      subnet_ids       = module.vpc.private_subnets[2]
      instance_type = var.worker_type
      tags = {
        "kubernetes.io/cluster/${local.cluster_name}/autoscalerenable" = "k8s.io/cluster-autoscaler/enabled"
        "kubernetes.io/cluster/${local.cluster_name}/autoscaler"  = "k8s.io/cluster-autoscaler/${local.cluster_name}"
      }
    }
  }
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}