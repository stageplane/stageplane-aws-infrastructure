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

output "cluster_name" {
  description = "Created EKS cluster name."
  value       = module.upstream_eks.cluster_name
  sensitive   = true
}
output "cluster_endpoint" {
  description = "Created EKS cluster endpoint."
  value       = module.upstream_eks.cluster_endpoint
  sensitive   = true
}
output "cluster_certificate_authority_data" {
  description = "Created EKS cluster CA bundle."
  value       = module.upstream_eks.cluster_certificate_authority_data
  sensitive   = true
}
output "oidc_provider_arn" {
  description = "OIDC provider ARN exposed by the upstream module."
  value       = module.upstream_eks.oidc_provider_arn
  sensitive   = true
}

output "node_security_group_id" {
  description = "Shared worker node security group identifier exported by the upstream module."
  value       = try(module.upstream_eks.node_security_group_id, null)
  sensitive   = true
}
