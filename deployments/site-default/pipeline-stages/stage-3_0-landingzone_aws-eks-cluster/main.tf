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
  stage_name = "landingzone-aws-eks-cluster"
}

data "terraform_remote_state" "general" {
  backend = "local"
  config = {
    path = "../stage-0_0-landingzone_general-config/terraform.tfstate"
  }
}

data "terraform_remote_state" "vpc" {
  backend = "local"
  config = {
    path = "../stage-1_0-landingzone_aws-vpc/terraform.tfstate"
  }
}

# -----------------------------------------------------------------------------
# Intent
# -----------------------------------------------------------------------------
# Stage 3 creates the Kubernetes control plane only after shared settings and
# network foundations are already present and exported through remote state.
# -----------------------------------------------------------------------------
module "landingzone_aws_eks_cluster" {
  source = "../../../../terraform-modules/landingzone-aws-eks-cluster"

  settings           = data.terraform_remote_state.general.outputs.settings
  vpc_id             = data.terraform_remote_state.vpc.outputs.vpc_id
  private_subnet_ids = data.terraform_remote_state.vpc.outputs.private_subnet_ids
}
