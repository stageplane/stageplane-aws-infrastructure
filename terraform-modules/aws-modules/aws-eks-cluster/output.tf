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
  description = "Cluster name exported by the managed node group child module."
  value       = module.managed_node_groups.cluster_name
  sensitive   = true
}

output "cluster_endpoint" {
  description = "Cluster API endpoint exported by the managed node group child module."
  value       = module.managed_node_groups.cluster_endpoint
  sensitive   = true
}

output "cluster_certificate_authority_data" {
  description = "Base64-encoded cluster CA bundle."
  value       = module.managed_node_groups.cluster_certificate_authority_data
  sensitive   = true
}

output "oidc_provider_arn" {
  description = "OIDC provider ARN retained for transitional compatibility."
  value       = module.managed_node_groups.oidc_provider_arn
  sensitive   = true
}

output "node_security_group_id" {
  description = "Node security group identifier used by cluster worker capacity."
  value       = module.managed_node_groups.node_security_group_id
  sensitive   = true
}
