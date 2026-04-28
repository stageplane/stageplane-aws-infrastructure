# -----------------------------------------------------------------------------
# Copyright
# -----------------------------------------------------------------------------
# Copyright (c) 2026 Vladimir Fonseca. All rights reserved.
#

# -----------------------------------------------------------------------------
# Intent
# -----------------------------------------------------------------------------
# Verifies the control-plane access placeholder contract without requiring live
# AWS access.
# -----------------------------------------------------------------------------

mock_provider "aws" {}

run "exports_access_placeholder_contract" {
  command = plan

  variables {
    cluster_name = "example-dev-us-west-2-eks"
    common_tags = {
      Environment = "dev"
      ManagedBy   = "Terraform"
    }
  }

  assert {
    condition     = length(output.principal_arns) == 0
    error_message = "The control-plane access module must default to an empty principal list."
  }
}
