# -----------------------------------------------------------------------------
# Copyright
# -----------------------------------------------------------------------------
# Copyright (c) 2026 Vladimir Fonseca. All rights reserved.
#

# -----------------------------------------------------------------------------
# File intent
# -----------------------------------------------------------------------------
# This module installs the self-managed Karpenter controller as an optional
# post-cluster capacity layer. The baseline managed node group remains the
# bootstrap foundation, while Karpenter is reserved for elastic workload pools.
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# Intent
# -----------------------------------------------------------------------------
# Keep the self-managed Karpenter controller install narrow and reusable:
# - create the controller namespace
# - install the pinned Helm release
# - inject only the minimum cluster identity values the chart needs
# -----------------------------------------------------------------------------

locals {
  chart_name = "karpenter"
  repository = "oci://public.ecr.aws/karpenter"
}

data "aws_partition" "current" {
  count = 0
}

# -----------------------------------------------------------------------------
# Intent
# -----------------------------------------------------------------------------
# Own the Karpenter namespace explicitly so labels and lifecycle remain under
# Terraform rather than being implicitly created by Helm.
# -----------------------------------------------------------------------------
resource "kubernetes_namespace" "karpenter" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/name"       = "karpenter"
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }
}

# -----------------------------------------------------------------------------
# Intent
# -----------------------------------------------------------------------------
# Install the self-managed Karpenter controller with a pinned chart version so
# the capacity layer is upgradeable through deliberate source control changes.
# -----------------------------------------------------------------------------
resource "helm_release" "karpenter" {
  name             = "karpenter"
  repository       = local.repository
  chart            = local.chart_name
  version          = var.chart_version
  namespace        = kubernetes_namespace.karpenter.metadata[0].name
  create_namespace = false

  set {
    name  = "settings.clusterName"
    value = var.cluster_name
  }

  set {
    name  = "settings.clusterEndpoint"
    value = var.cluster_endpoint
  }

  set {
    name  = "serviceAccount.create"
    value = "true"
  }

  set {
    name  = "serviceAccount.name"
    value = "karpenter"
  }

  dynamic "set" {
    for_each = var.irsa_role_arn == "" ? [] : [var.irsa_role_arn]

    content {
      name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
      value = set.value
    }
  }
}


# -----------------------------------------------------------------------------
# Intent
# -----------------------------------------------------------------------------
# Render optional Karpenter NodePool resources from the same compute contract
# used by managed node groups. Karpenter remains optional; when enabled without
# node_pools, only the controller is installed.
# -----------------------------------------------------------------------------
resource "kubernetes_manifest" "node_pool" {
  for_each = { for pool in var.node_pools : pool.name => pool }

  manifest = {
    apiVersion = "karpenter.sh/v1"
    kind       = "NodePool"
    metadata = {
      name = each.key
      labels = {
        "stageplane.io/role" = try(each.value.role, "general")
      }
    }
    spec = {
      template = {
        spec = {
          requirements = [
            {
              key      = "karpenter.sh/capacity-type"
              operator = "In"
              values   = [try(each.value.capacity.type, "spot")]
            },
            {
              key      = "node.kubernetes.io/instance-type"
              operator = "In"
              values   = try(each.value.instance.types, [])
            }
          ]
        }
      }
      limits = try(each.value.limits, null)
    }
  }

  depends_on = [helm_release.karpenter]
}
