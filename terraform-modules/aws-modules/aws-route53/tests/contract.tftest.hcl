# -----------------------------------------------------------------------------
# Copyright
# -----------------------------------------------------------------------------
# Copyright (c) 2026 Vladimir Fonseca. All rights reserved.
#

# -----------------------------------------------------------------------------
# Intent
# -----------------------------------------------------------------------------
# Verifies the Route53 private-zone module contract with a mocked AWS provider
# so the zone configuration can be validated without live AWS credentials.
# -----------------------------------------------------------------------------

mock_provider "aws" {}

run "exports_route53_contract" {
  command = plan

  variables {
    zone_name = "dev.example.internal"
    vpc_id    = "vpc-0123456789abcdef0"
    common_tags = {
      Environment = "dev"
      ManagedBy   = "Terraform"
    }
  }

  assert {
    condition     = output.zone_name == "dev.example.internal"
    error_message = "The Route53 module must normalize and expose the zone name."
  }
}
