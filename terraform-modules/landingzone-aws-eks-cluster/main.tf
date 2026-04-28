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
  common_tags = {
    Environment   = var.settings.environment
    ManagedBy     = "Terraform"
    PlatformLayer = "eks"
    Owner         = "platform"
  }

  cluster_name = var.settings.cluster_name
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

module "aws_eks_cluster" {
  source = "../aws-modules/aws-eks-cluster"

  cluster_name       = local.cluster_name
  cluster_version    = var.settings.cluster_version
  vpc_id             = var.vpc_id
  private_subnet_ids = var.private_subnet_ids
  node_groups        = var.settings.compute.node_groups
  common_tags        = local.common_tags
}
