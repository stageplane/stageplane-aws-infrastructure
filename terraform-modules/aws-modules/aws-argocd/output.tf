# -----------------------------------------------------------------------------
# Copyright
# -----------------------------------------------------------------------------
# Copyright (c) 2026 Vladimir Fonseca. All rights reserved.
#


output "namespace" {
  value     = kubernetes_namespace.argocd.metadata[0].name
  sensitive = true
}

output "server_service_name" {
  value     = "argocd-server"
  sensitive = true
}
