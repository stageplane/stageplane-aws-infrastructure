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
  description = "Combined set of add-ons enabled by this wrapper."
  value       = local.enabled_addons
  sensitive   = true
}
