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
  principal_arns = []
}

data "aws_partition" "current" {}

# -----------------------------------------------------------------------------
# Intent
# -----------------------------------------------------------------------------
# This module is intentionally minimal. It establishes the repository location
# where EKS access-entry resources and policy associations belong. Teams can add
# aws_eks_access_entry and aws_eks_access_policy_association resources here as
# principals are formalized.
# -----------------------------------------------------------------------------
