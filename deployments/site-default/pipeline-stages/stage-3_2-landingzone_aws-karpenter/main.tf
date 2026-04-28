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

# -----------------------------------------------------------------------------
# Intent
# -----------------------------------------------------------------------------
# Stage 3.2 layers optional self-managed Karpenter on top of the baseline EKS
# cluster only after the control plane exists. Site-scoped enablement and chart
# settings come from stage 0 normalized settings, not from an extra stage-local
# var-file.
# -----------------------------------------------------------------------------

locals {
  stage_name = "landingzone-aws-karpenter"
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

module "landingzone_aws_karpenter" {
  source = "../../../../terraform-modules/landingzone-aws-karpenter"

  settings             = data.terraform_remote_state.general.outputs.settings
  cluster_name         = data.terraform_remote_state.eks.outputs.cluster_name
  cluster_endpoint     = data.terraform_remote_state.eks.outputs.cluster_endpoint
  karpenter_node_pools = try(data.terraform_remote_state.general.outputs.settings.compute.karpenter.node_pools, [])
}
