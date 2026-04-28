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
  normalized_node_groups = var.node_groups

  eks_managed_node_groups = {
    for group in local.normalized_node_groups : group.name => {
      ami_type       = try(group.instance.ami_type, "AL2023_x86_64_STANDARD")
      instance_types = try(group.instance.types, [])
      min_size       = try(group.scaling.min, 0)
      max_size       = try(group.scaling.max, 0)
      desired_size   = try(group.scaling.desired, group.scaling.min, 0)
      capacity_type  = group.capacity.type == "spot" ? "SPOT" : "ON_DEMAND"
      labels = merge(
        {
          "stageplane.io/role"     = group.role
          "stageplane.io/capacity" = group.capacity.type
        },
        try(group.labels, {})
      )
      taints = try(group.taints, [])
    }
    if group.capacity.type != "fargate" && try(group.capacity.backend, "managed_node_group") == "managed_node_group"
  }

  fargate_profiles = {
    for group in local.normalized_node_groups : group.name => {
      selectors = [
        for namespace in try(group.fargate.namespaces, []) : {
          namespace = namespace
        }
      ]
    }
    if group.capacity.type == "fargate"
  }

  access_entries = {
    for index, principal_arn in var.access_entry_arns :
    format("entry-%02d", index + 1) => {
      principal_arn = principal_arn
      type          = "STANDARD"
      policy_associations = {
        admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      }
    }
  }
}
data "aws_region" "current" {}

module "upstream_eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.18"

  name               = var.cluster_name
  kubernetes_version = var.cluster_version

  endpoint_public_access  = true
  endpoint_private_access = true

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnet_ids

  create_cloudwatch_log_group = true
  enable_irsa                 = true
  authentication_mode         = "API"
  access_entries              = local.access_entries

  addons = {
    coredns                = {}
    kube-proxy             = {}
    vpc-cni                = {}
    eks-pod-identity-agent = {}
  }

  eks_managed_node_groups = local.eks_managed_node_groups
  fargate_profiles        = local.fargate_profiles

  tags = var.common_tags
}
