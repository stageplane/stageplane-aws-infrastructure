# -----------------------------------------------------------------------------
# Copyright
# -----------------------------------------------------------------------------
# Copyright (c) 2026 Vladimir Fonseca. All rights reserved.
#

# -----------------------------------------------------------------------------
# File intent
# -----------------------------------------------------------------------------
# This file defines the input contract for the module. Variables must describe
# intent, ownership scope, notable constraints, and example cases where helpful.
# -----------------------------------------------------------------------------

variable "cluster_name" {
  description = <<-EOT
  Canonical EKS cluster name the Karpenter controller targets.
  EOT
  type        = string
}

variable "cluster_endpoint" {
  description = <<-EOT
  Kubernetes API endpoint consumed by the Karpenter chart settings.
  EOT
  type        = string
}

variable "namespace" {
  description = <<-EOT
  Namespace that owns the Karpenter controller deployment.

  Example:
  - karpenter
  EOT
  type        = string
  default     = "karpenter"
}

variable "chart_version" {
  description = <<-EOT
  Karpenter chart version pinned for the self-managed controller release.

  Example:
  - 1.8.1
  EOT
  type        = string
  default     = "1.8.1"
}

variable "node_pools" {
  description = "StagePlane Karpenter node pools. Optional because Karpenter can be installed before any elastic pools are declared."
  type        = any
  default     = []
}
