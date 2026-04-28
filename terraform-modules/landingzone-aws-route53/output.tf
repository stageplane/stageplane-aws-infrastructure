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
  description = "Route53 hosted-zone identifier."
  value       = module.aws_route53.zone_id
  sensitive   = true
}

output "zone_name" {
  description = "Canonical hosted-zone name."
  value       = module.aws_route53.zone_name
  sensitive   = true
}
