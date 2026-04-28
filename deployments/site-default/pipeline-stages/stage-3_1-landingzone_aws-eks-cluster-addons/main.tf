# -----------------------------------------------------------------------------
# Copyright
# -----------------------------------------------------------------------------
# Copyright (c) 2026 Vladimir Fonseca. All rights reserved.
#

# -----------------------------------------------------------------------------
# File intent
# -----------------------------------------------------------------------------
# This file holds the implementation flow for the module. Per repository rule,
# blocks are ordered as locals, then data, then resources, and child modules at
# the end. If the module becomes too large, complexity must move into child
# modules instead of additional sibling Terraform files.
# -----------------------------------------------------------------------------


locals {
  stage_name = "landingzone-aws-eks-cluster-addons"
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

# -----------------------------------------------------------------------------
# Intent
# -----------------------------------------------------------------------------
# Stage 3.1 installs add-ons only after the cluster API exists, keeping cluster
# creation and post-cluster service enablement as separate operational steps.
# -----------------------------------------------------------------------------
module "landingzone_aws_eks_cluster_addons" {
  source = "../../../../terraform-modules/landingzone-aws-eks-cluster-addons"

  settings         = data.terraform_remote_state.general.outputs.settings
  cluster_name     = data.terraform_remote_state.eks.outputs.cluster_name
  cluster_endpoint = data.terraform_remote_state.eks.outputs.cluster_endpoint
}
