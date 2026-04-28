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
  description = <<-EOT
  VPC identifier associated with a private hosted zone.

  Example:
  - vpc-0123456789abcdef0
  EOT
  type        = string
}
