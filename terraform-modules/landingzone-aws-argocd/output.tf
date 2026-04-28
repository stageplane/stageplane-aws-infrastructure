# -----------------------------------------------------------------------------
# Copyright
# -----------------------------------------------------------------------------
# Copyright (c) 2026 Vladimir Fonseca. All rights reserved.
#


output "namespace" {
  description = "Namespace that owns the installed Argo CD release."
  value       = module.aws_argocd.namespace
  sensitive   = true
}

output "server_service_name" {
  description = "Argo CD server service name used by bootstrap automation."
  value       = module.aws_argocd.server_service_name
  sensitive   = true
}
