# Contract test for the managed node groups wrapper module.
# This test intentionally mocks providers and overrides the upstream EKS child
# module so the test remains offline, deterministic, and focused on this
# wrapper's output contract.

mock_provider "aws" {}
mock_provider "tls" {}
mock_provider "time" {}
mock_provider "cloudinit" {}
mock_provider "null" {}

run "exports_managed_node_group_contract" {
  command = plan

  variables {
    cluster_name       = "example-cluster"
    cluster_version    = "1.33"
    vpc_id             = "vpc-11111111"
    private_subnet_ids = ["subnet-11111111", "subnet-22222222"]
    node_groups = [
      {
        name = "system"
        role = "system"
        capacity = {
          type = "on_demand"
        }
        instance = {
          types = ["m7i.large"]
        }
        scaling = {
          desired = 2
          min     = 1
          max     = 3
        }
      },
      {
        name = "gpu-spot"
        role = "gpu"
        capacity = {
          type = "spot"
          spot = {
            max_price            = "12.50"
            allocation_strategy  = "price-capacity-optimized"
            fallback_to_ondemand = true
          }
        }
        instance = {
          types = ["p5.48xlarge", "p4d.24xlarge"]
        }
        scaling = {
          desired = 0
          min     = 0
          max     = 8
        }
      }
    ]
    access_entry_arns = []
    common_tags = {
      Environment = "test"
    }
  }

  override_module {
    target = module.upstream_eks

    outputs = {
      cluster_name                       = "example-cluster"
      cluster_endpoint                   = "https://example.eks.amazonaws.com"
      cluster_certificate_authority_data = "ZXhhbXBsZS1jYQ=="
      oidc_provider_arn                  = "arn:aws:iam::111111111111:oidc-provider/example"
      node_security_group_id             = "sg-node"
    }
  }

  assert {
    condition     = output.cluster_name == "example-cluster"
    error_message = "expected cluster name contract output to be preserved"
  }

  assert {
    condition     = output.cluster_endpoint == "https://example.eks.amazonaws.com"
    error_message = "expected cluster endpoint contract output to be preserved"
  }

  assert {
    condition     = output.node_security_group_id == "sg-node"
    error_message = "expected node security group contract output to be preserved"
  }

  assert {
    condition     = output.oidc_provider_arn == "arn:aws:iam::111111111111:oidc-provider/example"
    error_message = "expected OIDC provider ARN contract output to be preserved"
  }
}
