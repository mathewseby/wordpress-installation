#resource "aws_eks_cluster" "wp_eks" {
#  name       = "wp-eks"
#  role_arn   = aws_iam_role.eksclusterrole.arn
#  depends_on = [aws_iam_role.eksclusterrole, aws_iam_role.eksnoderole]
#  vpc_config {
#    subnet_ids         = var.kube_subnets
#    security_group_ids = var.kube_sgs
#  }
#}
#
#resource "aws_eks_node_group" "wp-eks-nodes" {
#  cluster_name    = aws_eks_cluster.wp_eks.name
#  node_group_name = "wp-nodegroup"
#  node_role_arn   = aws_iam_role.eksnoderole.arn
#  subnet_ids      = var.kube_subnets
#  scaling_config {
#    desired_size = 1
#    max_size     = 1
#    min_size     = 1
#  }
#}
#
#resource "aws_iam_role" "eksclusterrole" {
#  name = "eksrole"
#  assume_role_policy = jsonencode({
#    Version = "2012-10-17"
#    Statement = [
#      {
#        Action = "sts:AssumeRole"
#        Effect = "Allow"
#        Sid    = ""
#        Principal = {
#          Service = "eks.amazonaws.com"
#        }
#      },
#    ]
#  })
#  managed_policy_arns = [data.aws_iam_policy.ekspolicy.arn]
#}
#
#resource "aws_iam_role" "eksnoderole" {
#  name                = "eksnoderole"
#  managed_policy_arns = [data.aws_iam_policy.eksworker.arn, data.aws_iam_policy.containerregistry.arn, data.aws_iam_policy.ekscni.arn]
#  assume_role_policy = jsonencode({
#    Version = "2012-10-17"
#    Statement = [
#      {
#        Action = "sts:AssumeRole"
#        Effect = "Allow"
#        Sid    = ""
#        Principal = {
#          Service = "ec2.amazonaws.com"
#        }
#      },
#    ]
#  })
#}
#
#data "aws_iam_policy" "ekspolicy" {
#  arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
#}
#
#data "aws_iam_policy" "eksworker" {
#  arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
#}
#data "aws_iam_policy" "containerregistry" {
#  arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
#}
#data "aws_iam_policy" "ekscni" {
#  arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
#}