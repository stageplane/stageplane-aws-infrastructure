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
  description = "Target EKS cluster name for Argo CD integration."
  type        = string
}

variable "namespace" {
  description = "Namespace where the Argo CD Helm release is installed."
  type        = string
}

variable "chart_version" {
  description = "Pinned Helm chart version for Argo CD."
  type        = string
}
