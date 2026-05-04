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
  cluster_tags = merge(var.common_tags, {
    Name = var.cluster_name
  })
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

# -----------------------------------------------------------------------------
# Intent
# -----------------------------------------------------------------------------
# Keeps cluster access-entry logic isolated from the rest of cluster creation so
# platform teams can evolve principals, policies, and bootstrap rules without
# destabilizing the core control-plane or node-group implementation.
# -----------------------------------------------------------------------------
module "control_plane_access" {
  source = "./modules/control-plane-access"

  cluster_name = var.cluster_name
  common_tags  = local.cluster_tags
}

# -----------------------------------------------------------------------------
# Intent
# -----------------------------------------------------------------------------
# Owns the primary upstream EKS module call. This is the authoritative location
# for control-plane versioning, managed node groups, cluster authentication mode,
# and the baseline add-on posture tied directly to cluster lifecycle.
# -----------------------------------------------------------------------------
module "managed_node_groups" {
  source = "./modules/managed-node-groups"

  cluster_name                         = var.cluster_name
  cluster_version                      = var.cluster_version
  vpc_id                               = var.vpc_id
  private_subnet_ids                   = var.private_subnet_ids
  node_groups                          = var.node_groups
  cluster_endpoint_public_access_cidrs = var.cluster_endpoint_public_access_cidrs
  access_entry_arns                    = module.control_plane_access.principal_arns
  common_tags                          = local.cluster_tags
}

# -----------------------------------------------------------------------------
# Intent
# -----------------------------------------------------------------------------
# Reserves a dedicated composition point for EKS Pod Identity so workload
# credentials can be modeled independently from cluster provisioning and access
# administration.
# -----------------------------------------------------------------------------
module "pod_identity" {
  source = "./modules/pod-identity"

  cluster_name = var.cluster_name
  common_tags  = local.cluster_tags
}
