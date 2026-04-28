# -----------------------------------------------------------------------------
# Copyright
# -----------------------------------------------------------------------------
# Copyright (c) 2026 Vladimir Fonseca. All rights reserved.
#

# -----------------------------------------------------------------------------
# Intent
# -----------------------------------------------------------------------------
# Verifies the core-addons placeholder contract without requiring live AWS
# access.
# -----------------------------------------------------------------------------

mock_provider "aws" {}

run "exports_core_addon_contract" {
  command = plan

  variables {
    cluster_name = "example-dev-us-west-2-eks"
    common_tags = {
      Environment = "dev"
      ManagedBy   = "Terraform"
    }
  }

  assert {
    condition     = length(output.addon_names) == 2
    error_message = "The core-addons module must preserve the baseline managed add-on names."
  }
}
