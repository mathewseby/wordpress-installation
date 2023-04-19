module "eks" {
  source       = "./modules/eks"
  kube_subnets = [aws_subnet.eks-01.id, aws_subnet.eks-02.id]
  kube_sgs     = [aws_security_group.ec2_sg.id]
}

module "wp-eks-nodes" {
  source       = "./modules/eks"
  kube_subnets = [aws_subnet.eks-01.id, aws_subnet.eks-02.id]
}