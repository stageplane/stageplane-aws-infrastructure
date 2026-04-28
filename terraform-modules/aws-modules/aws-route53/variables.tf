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

variable "zone_name" {
  description = "Hosted-zone DNS suffix."
  type        = string
}

variable "vpc_id" {
  description = "VPC identifier to associate with the private hosted zone."
  type        = string
}

variable "common_tags" {
  description = "Repository-standard tags applied to the hosted zone when supported."
  type        = map(string)
  default     = {}
}
