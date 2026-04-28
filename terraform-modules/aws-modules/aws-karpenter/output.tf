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

output "namespace" {
  description = "Namespace used by the Karpenter controller release."
  value       = kubernetes_namespace.karpenter.metadata[0].name
  sensitive   = true
}

output "release_name" {
  description = "Helm release name for the Karpenter controller."
  value       = helm_release.karpenter.name
  sensitive   = true
}
