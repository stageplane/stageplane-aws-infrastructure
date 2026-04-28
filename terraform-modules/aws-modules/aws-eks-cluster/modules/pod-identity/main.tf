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
  pod_identity_examples = []
}

data "aws_partition" "current" {}

# -----------------------------------------------------------------------------
# Intent
# -----------------------------------------------------------------------------
# EKS Pod Identity is the preferred workload credential baseline for this
# repository. This child module is where aws_iam_role,
# aws_eks_pod_identity_association, and policy attachments should be added as
# platform services are onboarded.
# -----------------------------------------------------------------------------
