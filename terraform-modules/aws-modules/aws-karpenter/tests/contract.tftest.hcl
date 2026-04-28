# -----------------------------------------------------------------------------
# Copyright
# -----------------------------------------------------------------------------
# Copyright (c) 2026 Vladimir Fonseca. All rights reserved.
#

# -----------------------------------------------------------------------------
# Intent
# -----------------------------------------------------------------------------
# Verifies the optional self-managed Karpenter controller contract with mocked
# Kubernetes and Helm providers plus an explicit offline-safe AWS provider
# configuration so no live cloud or cluster credentials are needed.
# -----------------------------------------------------------------------------

provider "aws" {
  region                      = "us-west-2"
  access_key                  = "mock-access-key"
  secret_key                  = "mock-secret-key"
  token                       = "mock-session-token"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  skip_region_validation      = true
}

mock_provider "kubernetes" {}
mock_provider "helm" {}

run "exports_karpenter_contract" {
  command = plan

  variables {
    cluster_name     = "example-dev-us-west-2-eks"
    cluster_endpoint = "https://example.eks.amazonaws.com"
    namespace        = "karpenter"
    chart_version    = "1.8.1"
  }

  assert {
    condition     = output.namespace == "karpenter"
    error_message = "The Karpenter module must expose the controller namespace."
  }

  assert {
    condition     = output.release_name == "karpenter"
    error_message = "The Karpenter module must expose the Helm release name."
  }
}
