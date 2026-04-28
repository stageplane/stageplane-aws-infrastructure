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
  description = "Amazon EKS cluster name used by add-on and workload stages."
  value       = module.landingzone_aws_eks_cluster.cluster_name
  sensitive   = true
}

output "cluster_endpoint" {
  description = "Amazon EKS API endpoint for downstream providers and automation."
  value       = module.landingzone_aws_eks_cluster.cluster_endpoint
  sensitive   = true
}

output "oidc_provider_arn" {
  description = "OIDC provider contract retained for compatibility with legacy and transitional consumers."
  value       = module.landingzone_aws_eks_cluster.oidc_provider_arn
  sensitive   = true
}
