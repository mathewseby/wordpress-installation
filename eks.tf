#module "eks" {
#  source       = "./modules/eks"
#  kube_subnets = [aws_subnet.eks-01.id, aws_subnet.eks-02.id]
#  kube_sgs     = [aws_security_group.ec2_sg.id]
#}

#module "wp-eks-nodes" {
#  source       = "./modules/eks"
#  kube_subnets = [aws_subnet.eks-01.id, aws_subnet.eks-02.id]
#}

module "eks" {
  source                         = "terraform-aws-modules/eks/aws"
  version                        = "~> 19.0"
  cluster_name                   = "wp-eks"
  cluster_version                = "1.25"
  cluster_endpoint_public_access = true

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
    aws-ebs-csi-driver = {
      most_recent = true
    }

  }

  vpc_id                   = aws_vpc.vpc.id
  subnet_ids               = [aws_subnet.eks-01.id, aws_subnet.eks-02.id]
  control_plane_subnet_ids = [aws_subnet.eks-03.id, aws_subnet.eks-04.id]

  eks_managed_node_groups = {
    green = {
      min_size       = 1
      max_size       = 1
      desired_size   = 1
      instance_types = ["t3a.medium"]
      capacity_types = "On-Demand"
    }
  }
}
