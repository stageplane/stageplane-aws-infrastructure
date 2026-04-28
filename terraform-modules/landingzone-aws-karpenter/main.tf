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
# Provide the landing-zone composition point for optional self-managed
# Karpenter. This module keeps the site-level policy decision separate from the
# lower-level controller installation details.
# -----------------------------------------------------------------------------

locals {
  common_tags = {
    Environment   = var.settings.environment
    ManagedBy     = "Terraform"
    PlatformLayer = "eks-karpenter"
    Owner         = "platform"
  }
}

module "aws_karpenter" {
  source = "../aws-modules/aws-karpenter"

  cluster_name     = var.cluster_name
  cluster_endpoint = var.cluster_endpoint
  node_pools       = var.karpenter_node_pools
}
