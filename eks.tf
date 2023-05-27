

#resource "aws_eks_cluster" "wp_eks" {
#  count      = var.install_type == "eks" ? 1 : 0
#  name       = "wp-eks"
#  role_arn   = one(aws_iam_role.eksclusterrole[*].arn)
#  depends_on = [aws_iam_role.eksclusterrole, aws_iam_role.eksnoderole, aws_db_instance.wp-rds]
#  vpc_config {
#    subnet_ids         = ["${one(aws_subnet.eks-01[*].id)}", "${one(aws_subnet.eks-02[*].id)}"]
#    security_group_ids = ["${one(aws_security_group.eks-sg[*].id)}"]
#  }
#}
#
#resource "aws_eks_node_group" "wp-eks-nodes" {
#  cluster_name    = one(aws_eks_cluster.wp_eks[*].name)
#  node_group_name = "wp-nodegroup"
#  node_role_arn   = one(aws_iam_role.eksnoderole[*].arn)
#  subnet_ids      = ["${one(aws_subnet.eks-01[*].id)}", "${one(aws_subnet.eks-02[*].id)}"]
#  scaling_config {
#    desired_size = 1
#    max_size     = 1
#    min_size     = 1
#  }
#}

module "eks" {
  count                          = var.install_type == "eks" ? 1 : 0
  source                         = "terraform-aws-modules/eks/aws"
  version                        = "~> 19.0"
  cluster_name                   = "wp-eks"
  cluster_version                = "1.27"
  cluster_endpoint_public_access = true
  create_kms_key                 = false
  cluster_encryption_config      = {}


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
  subnet_ids               = [one(aws_subnet.eks-01[*].id), one(aws_subnet.eks-02[*].id)]
  control_plane_subnet_ids = [one(aws_subnet.eks-03[*].id), one(aws_subnet.eks-04[*].id)]

  eks_managed_node_groups = {
    green = {
      min_size       = 1
      max_size       = 1
      desired_size   = 1
      instance_types = ["t3a.medium"]
      capacity_types = "On-Demand"
    }
  }

  manage_aws_auth_configmap = true

  aws_auth_roles = [
    {
      rolearn  = aws_iam_role.admin.arn
      username = "admin"
      groups   = ["system:masters"]
    },
  ]


}

data "aws_eks_cluster" "default" {
  name = module.eks.cluster_name
}

data "aws_eks_cluster_auth" "default" {
  name = module.eks.cluster_name
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.default.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.default.token
}

resource "local_file" "kubeconfig" {
  filename = "kubeconfig"
  content  = local.kubeconfig
}