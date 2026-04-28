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

output "enabled_addons" {
  description = "Set of add-ons enabled by the baseline add-on stage."
  value       = module.landingzone_aws_eks_cluster_addons.enabled_addons
  sensitive   = true
}
