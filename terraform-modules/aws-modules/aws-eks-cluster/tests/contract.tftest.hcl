# -----------------------------------------------------------------------------
# Copyright
# -----------------------------------------------------------------------------
# Copyright (c) 2026 Vladimir Fonseca. All rights reserved.
#

# -----------------------------------------------------------------------------
# Intent
# -----------------------------------------------------------------------------
# Verifies the EKS cluster wrapper contract while keeping the test fully offline
# and deterministic. The test mocks providers and overrides direct child module
# boundaries so no third-party upstream EKS logic is evaluated.
# -----------------------------------------------------------------------------

mock_provider "aws" {}
mock_provider "tls" {}
mock_provider "time" {}
mock_provider "cloudinit" {}
mock_provider "null" {}

override_module {
  target = module.control_plane_access

  outputs = {
    principal_arns = []
  }
}

override_module {
  target = module.managed_node_groups

  outputs = {
    cluster_name                       = "example-dev-us-west-2-eks"
    cluster_endpoint                   = "https://example.eks.amazonaws.com"
    cluster_certificate_authority_data = "ZXhhbXBsZS1jYQ=="
    oidc_provider_arn                  = "arn:aws:iam::123456789012:oidc-provider/example"
    node_security_group_id             = "sg-0123456789abcdef0"
  }
}

override_module {
  target = module.pod_identity

  outputs = {
    pod_identity_examples = []
  }
}

run "exports_cluster_contract" {
  command = plan

  variables {
    cluster_name       = "example-dev-us-west-2-eks"
    cluster_version    = "1.33"
    vpc_id             = "vpc-0123456789abcdef0"
    private_subnet_ids = ["subnet-private-a", "subnet-private-b"]
    common_tags = {
      Environment = "dev"
      ManagedBy   = "Terraform"
    }
  }

  assert {
    condition     = output.cluster_name == "example-dev-us-west-2-eks"
    error_message = "The EKS cluster wrapper must preserve the cluster name contract."
  }

  assert {
    condition     = output.cluster_endpoint == "https://example.eks.amazonaws.com"
    error_message = "The EKS cluster wrapper must preserve the cluster endpoint contract."
  }

  assert {
    condition     = output.cluster_certificate_authority_data == "ZXhhbXBsZS1jYQ=="
    error_message = "The EKS cluster wrapper must preserve the cluster certificate authority contract."
  }

  assert {
    condition     = output.oidc_provider_arn == "arn:aws:iam::123456789012:oidc-provider/example"
    error_message = "The EKS cluster wrapper must preserve the OIDC provider ARN contract."
  }

  assert {
    condition     = output.node_security_group_id == "sg-0123456789abcdef0"
    error_message = "The EKS cluster wrapper must preserve the node security group contract."
  }
}
