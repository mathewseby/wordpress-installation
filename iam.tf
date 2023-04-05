resource "aws_iam_role" "eksclusterrole" {
  count = var.install_type == "eks" ? 1 : 0
  name  = "eksclusterrole"
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

data "aws_iam_policy" "ekspolicy" {
  arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}