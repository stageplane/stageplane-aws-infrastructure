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

output "zone_id" {
  description = "Identifier of the private hosted zone."
  value       = aws_route53_zone.private.zone_id
  sensitive   = true
}

output "zone_name" {
  description = "Normalized hosted-zone name without a trailing dot in configuration inputs."
  value       = aws_route53_zone.private.name
  sensitive   = true
}
