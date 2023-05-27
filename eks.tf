#module "eks" {
#  source       = "./modules/eks"
#  kube_subnets = [aws_subnet.eks-01.id, aws_subnet.eks-02.id]
#  kube_sgs     = [aws_security_group.ec2_sg.id]
#}

#module "wp-eks-nodes" {
#  source       = "./modules/eks"
#  kube_subnets = [aws_subnet.eks-01.id, aws_subnet.eks-02.id]
#}

#provider "kubernetes" {
#  host                   = module.eks.cluster_endpoint
#  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
#  exec {
#    api_version = "client.authentication.k8s.io/v1beta1"
#    command     = "/bin/sh"
#    args        = ["-c", "for i in $(seq 1 30); do curl -s -k -f ${module.eks.cluster_endpoint}/healthz > /dev/null && break || sleep 10; done && aws eks --region ${var.region} get-token --cluster-name ${module.eks.cluster_name}"]
#  }
#}
#data "aws_eks_cluster" "cluster" {
#  name = module.cluster.cluster_id
#}
#
#data "aws_eks_cluster_auth" "cluster" {
#  name = module.cluster.cluster_id
#}

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

module "eks" {
  source                         = "terraform-aws-modules/eks/aws"
  version                        = "19.12.0"
  cluster_name                   = "wp-eks"
  cluster_version                = "1.25"
  cluster_endpoint_public_access = true
  create_kms_key = false
  attach_cluster_encryption_policy = false
  cluster_encryption_config = {}

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

    manage_aws_auth_configmap = true

    aws_auth_roles = [
    {
      rolearn  = "arn:aws:iam::279601183831:role/developer"
      username = "developer"
      groups   = ["development"]
    },
  ]

   aws_auth_users = [
      {
        userarn  = "arn:aws:iam::279601183831:user/mathew-tf-test"
        username = "mathew-tf-test"
        groups   = ["system:masters"]
      },
    ]

}

locals {

  kubeconfig_name = "kube_config"

  kubeconfig = templatefile("${path.module}/templates/kubeconfig.tpl",
    {
      kubeconfig_name                    = module.eks.cluster_arn
      endpoint                          = module.eks.cluster_name
      cluster_auth_base64               = module.eks.cluster_certificate_authority_data
      aws_authenticator_api_version     = "client.authentication.k8s.io/v1beta1"
      aws_authenticator_command         = "aws-iam-authenticator"
      aws_authenticator_command_args    = ["token", "-i", module.eks.cluster_name, "-r", "arn:aws:iam::279601183831:role/developer"]
      aws_authenticator_additional_args = ["--region", var.region]
      aws_authenticator_env_variables   = []
    }
  )
}


output "kube_confg" {
  value = local.kubeconfig
}

resource "aws_iam_role" "developer" {
  name                = "developer"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": aws_iam_role.bastion-role.arn,
                "Service": "ec2.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
})
}

resource "aws_iam_role" "bastion-role" {
  name = "bastionrole"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
})

inline_policy {
  name = "bastionpolicy"
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "sts:GetSessionToken",
                "sts:DecodeAuthorizationMessage",
                "sts:GetAccessKeyInfo",
                "sts:GetCallerIdentity",
                "sts:GetServiceBearerToken"
            ],
            "Resource": "*"
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": "sts:*",
            "Resource": [
                "arn:aws:iam::279601183831:user/*",
                "arn:aws:iam::279601183831:role/*"
            ]
        }
    ]
})
}
}

resource "aws_iam_instance_profile" "bastion-profile" {
  name = "bastion-instance-profile"
  role = aws_iam_role.bastion-role.name

}

#data "aws_eks_cluster" "sandbox_cluster" {
#  depends_on = [module.eks]
#  name = module.eks.cluster_name
#}
#
#data "aws_eks_cluster_auth" "sandbox_cluster_auth" {
#  depends_on = [module.eks]
#  name = module.eks.cluster_name
#}
#
#provider "kubernetes" {
#  alias                  = "sandbox_kubernetes"
#  host                   = data.aws_eks_cluster.sandbox_cluster.endpoint
#  cluster_ca_certificate = base64decode(data.aws_eks_cluster.sandbox_cluster.certificate_authority[0].data)
#  token                  = data.aws_eks_cluster_auth.sandbox_cluster_auth.token
#}

#module "eks_auth" {
#  source = "aidanmelen/eks-auth/aws"
#  eks    = module.eks
#  providers = {
#    kubernetes = kubernetes.sandbox_kubernetes
#  }
#  map_users = [
#    {
#      userarn  = "arn:aws:iam::279601183831:user/mathewseby"
#      username = "mathewseby"
#      groups   = ["system:masters", "system:nodes"]
#    }
#  ]
#  map_accounts = [
#   "279601183831"
#  ]
#
#}

#output "kube_config" {
#  value = module.eks.kubeconfig
#}
