terraform {
  required_version = ">= 1.3" # Modern TF version
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.40" # Updated to a more recent v5 point release
    }
  }
}

provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {}

# 1. EKS Cluster Module (Modernized)

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.30"

  # Networking
  vpc_id                   = module.eks-vpc.vpc_id
  subnet_ids               = module.eks-vpc.private_subnets
  control_plane_subnet_ids = module.eks-vpc.private_subnets

  # Access Configuration (The "Credentials Fix")
  # 1. Use the new API mode instead of just the old configmap
  authentication_mode = "API_AND_CONFIG_MAP"
  
  # 2. Automatically give the identity running Terraform full cluster access
  enable_cluster_creator_admin_permissions = true

  # Networking & Connectivity
  cluster_endpoint_public_access = true

  cluster_addons = {
    coredns                = { most_recent = true }
    kube-proxy             = { most_recent = true }
    vpc-cni                = { most_recent = true }
    eks-pod-identity-agent = { most_recent = true } # Modern IAM for pods
  }

  # Node Groups
  eks_managed_node_groups = {
    default = {
      # t3.medium is safer; t3.small often runs out of memory for system pods
      instance_types = ["t3.medium"]
      
      min_size     = 1
      max_size     = 3
      desired_size = var.desired_nodes

      # Bottlerocket is the modern, hardened OS for EKS
      ami_type = "BOTTLEROCKET_x86_64"
      
      # Ensure nodes have enough disk for images
      disk_size = 20
    }
  }

  # Tagging for visibility
  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}




# 2. Access Configuration (Now correctly recognized by the module above)
resource "aws_eks_access_entry" "admins" {
  for_each      = toset(var.admin_users)
  cluster_name  = module.eks.cluster_name 
  principal_arn = each.value
  type          = "STANDARD"
}

resource "aws_eks_access_policy_association" "admins" {
  for_each      = toset(var.admin_users)
  cluster_name  = module.eks.cluster_name
  principal_arn = each.value
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }
}

# 3. VPC Module (Standard clean setup)
module "eks-vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "${var.cluster_name}-vpc"
  cidr = "10.0.0.0/16"

  azs             = slice(data.aws_availability_zones.available.names, 0, 2)
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"] 
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
  }
  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
  }
}