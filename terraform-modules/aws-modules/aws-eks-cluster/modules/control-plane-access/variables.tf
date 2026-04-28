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
  description = "Cluster name that will receive access entries."
  type        = string
}

variable "common_tags" {
  description = "Repository-standard tags for access-related resources when supported."
  type        = map(string)
  default     = {}
}
