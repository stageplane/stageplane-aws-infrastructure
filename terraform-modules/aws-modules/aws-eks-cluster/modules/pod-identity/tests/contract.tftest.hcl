# -----------------------------------------------------------------------------
# Copyright
# -----------------------------------------------------------------------------
# Copyright (c) 2026 Vladimir Fonseca. All rights reserved.
#

# -----------------------------------------------------------------------------
# Intent
# -----------------------------------------------------------------------------
# Verifies the Pod Identity placeholder contract without requiring live AWS
# access.
# -----------------------------------------------------------------------------

mock_provider "aws" {}

run "exports_pod_identity_placeholder_contract" {
  command = plan

  variables {
    cluster_name = "example-dev-us-west-2-eks"
    common_tags = {
      Environment = "dev"
      ManagedBy   = "Terraform"
    }
  }

  assert {
    condition     = length(output.pod_identity_examples) == 0
    error_message = "The Pod Identity module must default to an empty placeholder list."
  }
}
