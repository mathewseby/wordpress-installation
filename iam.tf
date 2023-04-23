#resource "aws_iam_role" "eksclusterrole" {
#  count = var.install_type == "eks" ? 1 : 0
#  name  = "eksrole"
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
#  count               = var.install_type == "eks" ? 1 : 0
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

#data "aws_iam_role" "ec2_eks_role" {
#  name = "ec2-eks-role"
#}
#
#resource "aws_iam_policy" "ec2_eks_policy" {
#  name   = "ec2-eks-policy"
#  policy = data.aws_iam_policy_document.ec2_eks_policy.json
#}
#
#resource "aws_iam_role_policy_attachment" "ec2_eks" {
#  role       = data.aws_iam_role.ec2_eks_role.name
#  policy_arn = aws_iam_policy.ec2_eks_policy.arn
#}
#
#data "aws_iam_policy_document" "ec2_eks_policy" {
#  statement {
#    effect = "Allow"
#
#    actions   = ["eks:*"]
#    resources = ["${one(aws_eks_cluster.wp_eks[*].arn)}"]
#  }
#
#  statement {
#    effect = "Allow"
#
#    actions = [
#      "iam:PassRole",
#    ]
#
#    condition {
#      test     = "StringEqualsIfExists"
#      variable = "iam:PassedToService"
#
#      values = [
#        "eks.amazonaws.com",
#      ]
#    }
#
#    resources = ["*"]
#  }
#}
#
#resource "aws_iam_instance_profile" "eks_ec2_profile" {
#  name = "eks-ec2-profile"
#  role = data.aws_iam_role.ec2_eks_role.name
#}

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
