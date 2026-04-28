# -----------------------------------------------------------------------------
# Copyright
# -----------------------------------------------------------------------------
# Copyright (c) 2026 Vladimir Fonseca. All rights reserved.
#
# -----------------------------------------------------------------------------
# Intent
# -----------------------------------------------------------------------------
# Native terraform test coverage for aws-eks-cluster-addons.
# Ensures the wrapper can plan with mocked providers and that the exported
# add-on contract remains stable for downstream landing-zone stages.
# -----------------------------------------------------------------------------

mock_provider "aws" {}

run "plan_addons_contract" {
  command = plan

  variables {
    cluster_name = "test-cluster"
    common_tags  = {}
  }

  assert {
    condition     = length(output.enabled_addons) == 3
    error_message = "aws-eks-cluster-addons must export exactly three enabled baseline add-ons."
  }

  assert {
    condition     = contains(output.enabled_addons, "metrics-server")
    error_message = "aws-eks-cluster-addons must preserve metrics-server in the exported baseline set."
  }
}
