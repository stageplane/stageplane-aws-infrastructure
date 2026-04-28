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
  description = "Cluster name for Pod Identity associations."
  type        = string
}

variable "common_tags" {
  description = "Repository-standard tags."
  type        = map(string)
  default     = {}
}
