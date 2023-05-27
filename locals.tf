locals {
  ssh_user         = var.ssh-user
  key_name         = var.instance_key_name
  private_key_path = var.private_key_path
}

locals {

  kubeconfig_name = "kube_config"

  kubeconfig = templatefile("${path.module}/templates/kubeconfig.tpl",
    {
      kubeconfig_name                   = module.eks.cluster_arn
      endpoint                          = module.eks.cluster_endpoint
      cluster_auth_base64               = module.eks.cluster_certificate_authority_data
      aws_authenticator_api_version     = "client.authentication.k8s.io/v1beta1"
      aws_authenticator_command         = "aws-iam-authenticator"
      aws_authenticator_command_args    = ["token", "-i", module.eks.cluster_name, "-r", aws_iam_role.admin.arn]
      aws_authenticator_additional_args = ["--region", var.region]
      aws_authenticator_env_variables   = []
    }
  )
}