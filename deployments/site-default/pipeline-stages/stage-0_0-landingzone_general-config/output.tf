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

# -----------------------------------------------------------------------------
# Intent
# -----------------------------------------------------------------------------
# Exposes the normalized settings contract to later stages.
# -----------------------------------------------------------------------------
output "settings" {
  description = "Normalized platform settings used by later stages."
  value       = module.landingzone_global_settings.settings
  sensitive   = true
}

# -----------------------------------------------------------------------------
# Backend bootstrap contract
# -----------------------------------------------------------------------------
# StagePlane reads this output after stage-0_0 completes in managed mode. Later
# stages use the controller-rendered backend config derived from this contract.
# -----------------------------------------------------------------------------
output "tf_backend" {
  description = "Remote state backend configuration produced by the bootstrap stage."
  value = local.managed_s3_backend ? {
    mode           = "managed"
    type           = "s3"
    bucket         = aws_s3_bucket.tf_state[0].bucket
    region         = var.aws_region
    dynamodb_table = aws_dynamodb_table.tf_lock[0].name
    key_prefix     = try(local.backend_config.key_prefix, "")
    encrypt        = "true"
  } : var.backend
  sensitive = true
}
