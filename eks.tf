//resource "aws_eks_cluster" "wp_eks" {
//  count      = var.install_type == "eks" ? 1 : 0
//  name       = "wp-eks"
//  role_arn   = "aws_iam_role.eksclusterrole.arn"
//  depends_on = [aws_iam_role.eksclusterrole]
//  vpc_config {
//    subnet_ids = ["${one(aws_subnet.eks-01[*].id)}", "${one(aws_subnet.eks-02[*].id)}"]
//  }
//}