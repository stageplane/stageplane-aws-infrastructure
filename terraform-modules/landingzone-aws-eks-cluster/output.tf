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
  description = "Amazon EKS cluster name."
  value       = module.aws_eks_cluster.cluster_name
  sensitive   = true
}

output "cluster_endpoint" {
  description = "Amazon EKS API endpoint."
  value       = module.aws_eks_cluster.cluster_endpoint
  sensitive   = true
}

output "cluster_certificate_authority_data" {
  description = "Base64-encoded cluster CA bundle used by Kubernetes and Helm providers."
  value       = module.aws_eks_cluster.cluster_certificate_authority_data
  sensitive   = true
}

output "oidc_provider_arn" {
  description = "OIDC provider ARN retained for transitional consumers even when Pod Identity is preferred."
  value       = module.aws_eks_cluster.oidc_provider_arn
  sensitive   = true
}
