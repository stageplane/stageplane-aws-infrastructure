# -----------------------------------------------------------------------------
# Copyright
# -----------------------------------------------------------------------------
# Copyright (c) 2026 Vladimir Fonseca. All rights reserved.
#


# -----------------------------------------------------------------------------
# File intent
# -----------------------------------------------------------------------------
# Deliberate integration outputs from the Argo CD installation stage.
# -----------------------------------------------------------------------------

output "namespace" {
  description = "Namespace used by the installed Argo CD control plane."
  value       = module.landingzone_aws_argocd.namespace
  sensitive   = true
}

output "server_service_name" {
  description = "Argo CD server service name used by runtime bootstrap automation."
  value       = module.landingzone_aws_argocd.server_service_name
  sensitive   = true
}
