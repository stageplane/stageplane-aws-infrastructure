# -----------------------------------------------------------------------------
# Copyright
# -----------------------------------------------------------------------------
# Copyright (c) 2026 Vladimir Fonseca. All rights reserved.
#

# -----------------------------------------------------------------------------
# File intent
# -----------------------------------------------------------------------------
# This file defines the input contract for the optional Karpenter composition
# stage. The controller remains optional and receives NodePool intent from the
# unified settings.compute contract.
# -----------------------------------------------------------------------------

variable "settings" {
  description = "Canonical settings object from stage 0 remote state."
  type        = any
}

variable "cluster_name" {
  description = "Target EKS cluster name."
  type        = string
}

variable "cluster_endpoint" {
  description = "Target EKS cluster API endpoint."
  type        = string
}

variable "karpenter_enabled" {
  description = "Enables the optional self-managed Karpenter controller for this site."
  type        = bool
  default     = false
}

variable "karpenter_namespace" {
  description = "Namespace used by the Karpenter controller."
  type        = string
  default     = "karpenter"
}

variable "karpenter_chart_version" {
  description = "Pinned Karpenter chart version for this site."
  type        = string
  default     = "1.8.1"
}

variable "karpenter_irsa_role_arn" {
  description = "Optional IAM role ARN annotated onto the Karpenter controller service account."
  type        = string
  default     = ""
}

variable "karpenter_node_pools" {
  description = "Optional StagePlane Karpenter node pools rendered from settings.compute.karpenter.node_pools."
  type        = any
  default     = []
}
