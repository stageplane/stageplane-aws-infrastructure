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
  addon_names = [
    "aws-ebs-csi-driver",
    "eks-pod-identity-agent",
  ]
}

data "aws_eks_cluster" "target" {
  name = var.cluster_name
}

# -----------------------------------------------------------------------------
# Intent
# -----------------------------------------------------------------------------
# This child module is the reserved location for aws_eks_addon resources that
# the platform wants to manage directly. Teams can extend it with addon version
# pinning and conflict-resolution policies per environment.
# -----------------------------------------------------------------------------
