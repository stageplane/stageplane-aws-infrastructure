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

# -----------------------------------------------------------------------------
# Intent
# -----------------------------------------------------------------------------
# Stable contract representing normalized platform-wide settings.
# The shape intentionally mirrors the stage-0 output so that all later modules
# consume one consistent object instead of many loosely coupled variables.
# -----------------------------------------------------------------------------
variable "settings" {
  description = <<-EOT
  Canonical StagePlane settings object exported by the general configuration
  stage. The compute contract is intentionally nested under settings.compute so
  managed node groups, Fargate profiles, and optional Karpenter node pools share
  one source of truth.
  EOT
  type        = any
}


variable "vpc_id" {
  description = "VPC identifier that will contain the EKS control plane and worker networking."
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet identifiers used by the cluster control plane and managed node groups."
  type        = list(string)
}
