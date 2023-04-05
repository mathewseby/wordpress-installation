resource "aws_iam_role" "eksclusterrole" {
  #count = var.install_type == "eks" ? 1 : 0
  name = "eksrole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
  managed_policy_arns = [data.aws_iam_policy.ekspolicy.arn]
}

resource "aws_iam_role" "eksnoderole" {
  name                = "eksnoderole"
  managed_policy_arns = [data.aws_iam_policy.eksworker.arn, data.aws_iam_policy.containerregistry.arn, data.aws_iam_policy.ekscni.arn]
}

data "aws_iam_policy" "ekspolicy" {
  arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

data "aws_iam_policy" "eksworker" {
  arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}
data "aws_iam_policy" "containerregistry" {
  arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}
data "aws_iam_policy" "ekscni" {
  arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}
