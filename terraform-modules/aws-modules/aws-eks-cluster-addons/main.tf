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
  enabled_addons = toset([
    "aws-ebs-csi-driver",
    "metrics-server",
    "aws-load-balancer-controller",
  ])
}

data "aws_eks_cluster" "target" {
  name = var.cluster_name
}

module "core_addons" {
  source = "./modules/core-addons"

  cluster_name = var.cluster_name
  common_tags  = var.common_tags
}
