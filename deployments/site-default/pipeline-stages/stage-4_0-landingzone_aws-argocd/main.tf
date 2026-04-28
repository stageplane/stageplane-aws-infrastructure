# -----------------------------------------------------------------------------
# Copyright
# -----------------------------------------------------------------------------
# Copyright (c) 2026 Vladimir Fonseca. All rights reserved.
#


# -----------------------------------------------------------------------------
# File intent
# -----------------------------------------------------------------------------
# Stage 4 installs Argo CD into the provisioned EKS cluster. This stage creates
# the durable cluster-side control-plane resources only. The runtime activation
# sequence remains in stagectl so bootstrap credentials and GitOps sources do
# not become static Terraform state.
# -----------------------------------------------------------------------------

locals {
  stage_name = "landingzone-aws-argocd"
}

data "terraform_remote_state" "general" {
  backend = "local"
  config = {
    path = "../stage-0_0-landingzone_general-config/terraform.tfstate"
  }
}

data "terraform_remote_state" "eks" {
  backend = "local"
  config = {
    path = "../stage-3_0-landingzone_aws-eks-cluster/terraform.tfstate"
  }
}

module "landingzone_aws_argocd" {
  source = "../../../../terraform-modules/landingzone-aws-argocd"

  settings         = data.terraform_remote_state.general.outputs.settings
  cluster_name     = data.terraform_remote_state.eks.outputs.cluster_name
  cluster_endpoint = data.terraform_remote_state.eks.outputs.cluster_endpoint
}
