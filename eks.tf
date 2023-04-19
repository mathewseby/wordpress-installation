module "eks" {
  source       = "./modules/eks"
  kube_subnets = [aws_subnet.eks-01, aws_subnet.eks-02]
  kube_sgs     = [aws_security_group.ec2_sg.id]
}

module "wp-eks-nodes" {
  source       = "./modules/eks"
  kube_subnets = [aws_subnet.eks-01, aws_subnet.eks-02]
}