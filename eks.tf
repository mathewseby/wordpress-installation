resource "aws_eks_cluster" "wp_eks" {
  count      = var.install_type == "eks" ? 1 : 0
  name       = "wp-eks"
  role_arn   = aws_iam_role.eksclusterrole.arn
  depends_on = [aws_iam_role.eksclusterrole, aws_iam_role.eksnoderole, aws_db_instance.wp-rds]
  vpc_config {
    subnet_ids         = ["${one(aws_subnet.eks-01[*].id)}", "${one(aws_subnet.eks-02[*].id)}"]
    security_group_ids = ["${one(aws_security_group.eks-sg[*].id)}"]
  }
}

resource "aws_eks_node_group" "wp-eks-nodes" {
  cluster_name    = one(aws_eks_cluster.wp_eks[*].name)
  node_group_name = "wp-nodegroup"
  node_role_arn   = aws_iam_role.eksnoderole.arn
  subnet_ids      = ["${one(aws_subnet.eks-01[*].id)}", "${one(aws_subnet.eks-02[*].id)}"]
  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }
}