module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.29"

  vpc_id     = aws_vpc.main.id
  subnet_ids = [aws_subnet.priv_1a.id, aws_subnet.priv_1b.id]

  cluster_endpoint_public_access = true

  self_managed_node_groups = {
    standard = {
      name          = "${var.project_name}-self-managed"
      instance_type = "t3.medium"
      
      min_size     = 1
      max_size     = 3
      desired_size = 2
    }
  }

  enable_cluster_creator_admin_permissions = true
  enable_irsa = true
}