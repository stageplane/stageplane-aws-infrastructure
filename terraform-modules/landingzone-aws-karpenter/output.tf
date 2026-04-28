# -----------------------------------------------------------------------------
# Copyright
# -----------------------------------------------------------------------------
# Copyright (c) 2026 Vladimir Fonseca. All rights reserved.
#

# -----------------------------------------------------------------------------
# File intent
# -----------------------------------------------------------------------------
# This file defines the output contract for the module. Outputs should expose
# only deliberate integration points for downstream stages and modules.
# -----------------------------------------------------------------------------

output "enabled" {
  description = "Whether self-managed Karpenter is enabled for this site."
  value       = var.karpenter_enabled
  sensitive   = true
}

output "namespace" {
  description = "Namespace used by the Karpenter controller when enabled."
  value       = var.karpenter_namespace
  sensitive   = true
}
