# -----------------------------------------------------------------------------
# Copyright
# -----------------------------------------------------------------------------
# Copyright (c) 2026 Vladimir Fonseca. All rights reserved.
#

# -----------------------------------------------------------------------------
# Intent
# -----------------------------------------------------------------------------
# Verifies the Argo CD installation module contract with mocked providers so the
# test remains cloud-independent and does not require a live Kubernetes cluster.
# -----------------------------------------------------------------------------

mock_provider "aws" {}
mock_provider "kubernetes" {}
mock_provider "helm" {}

run "exports_argocd_contract" {
  command = plan

  variables {
    cluster_name  = "example-dev-us-west-2-eks"
    namespace     = "argocd"
    chart_version = "7.7.16"
  }

  assert {
    condition     = output.namespace == "argocd"
    error_message = "The Argo CD module must expose the target namespace."
  }

  assert {
    condition     = output.server_service_name == "argocd-server"
    error_message = "The Argo CD module must expose the canonical Argo CD server service name."
  }
}
