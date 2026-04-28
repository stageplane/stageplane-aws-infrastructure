# -----------------------------------------------------------------------------
# Copyright
# -----------------------------------------------------------------------------
# Copyright (c) 2026 Vladimir Fonseca. All rights reserved.
#

# -----------------------------------------------------------------------------
# File intent
# -----------------------------------------------------------------------------
# This file defines the output contract for the optional Karpenter stage.
# -----------------------------------------------------------------------------

output "karpenter_enabled" {
  description = "Whether self-managed Karpenter was enabled for this site."
  value       = module.landingzone_aws_karpenter.enabled
  sensitive   = true
}
