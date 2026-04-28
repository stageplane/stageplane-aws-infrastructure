# -----------------------------------------------------------------------------
# Copyright
# -----------------------------------------------------------------------------
# Copyright (c) 2026 Vladimir Fonseca. All rights reserved.
#

# -----------------------------------------------------------------------------
# Intent
# -----------------------------------------------------------------------------
# Verifies the landing-zone EKS composition contract while keeping the test
# fully offline and deterministic. The test mocks providers and overrides the
# direct aws_eks_cluster child module so no nested upstream EKS logic is
# evaluated.
# -----------------------------------------------------------------------------

mock_provider "aws" {}
mock_provider "tls" {}
mock_provider "time" {}
mock_provider "cloudinit" {}
mock_provider "null" {}
mock_provider "kubernetes" {}
mock_provider "helm" {}

override_module {
  target = module.aws_eks_cluster

  outputs = {
    cluster_name                       = "example-dev-us-west-2-eks"
    cluster_endpoint                   = "https://example.eks.amazonaws.com"
    cluster_certificate_authority_data = "ZXhhbXBsZS1jYQ=="
    oidc_provider_arn                  = "arn:aws:iam::123456789012:oidc-provider/example"
    node_security_group_id             = "sg-0123456789abcdef0"
  }
}

run "exports_landingzone_eks_contract" {
  command = plan

  variables {
    settings = {
      platform_name        = "platform"
      environment          = "dev"
      aws_region           = "us-west-2"
      aws_profile          = "default"
      company_name         = "example"
      cluster_name         = "example-dev-us-west-2-eks"
      hosted_zone_name     = "dev.example.internal"
      vpc_cidr             = "10.0.0.0/16"
      availability_zones   = ["us-west-2a", "us-west-2b"]
      private_subnet_cidrs = ["10.0.0.0/20", "10.0.16.0/20"]
      public_subnet_cidrs  = ["10.0.128.0/24", "10.0.129.0/24"]
      cluster_version      = "1.33"
      compute = {
        node_groups = [
          {
            name     = "system"
            role     = "system"
            capacity = { type = "on_demand", backend = "managed_node_group" }
            instance = { types = ["m7i.large"] }
            scaling  = { desired = 3, min = 3, max = 6 }
          }
        ]
        karpenter = { enabled = false, namespace = "karpenter", chart_version = "1.8.1", node_pools = [] }
      }
      argocd_enabled             = true
      argocd_namespace           = "argocd"
      argocd_chart_version       = "7.7.16"
      argocd_bootstrap_enabled   = true
      argocd_base_kustomize      = "github.com/example/platform//argocd/base?ref=main"
      argocd_bootstrap_kustomize = "github.com/example/platform//argocd/bootstrap?ref=main"
      argocd_admin_password      = "placeholder"
    }
    vpc_id             = "vpc-0123456789abcdef0"
    private_subnet_ids = ["subnet-private-a", "subnet-private-b"]
  }

  assert {
    condition     = output.cluster_name == "example-dev-us-west-2-eks"
    error_message = "The landing-zone EKS module must expose the cluster name."
  }

  assert {
    condition     = output.cluster_endpoint == "https://example.eks.amazonaws.com"
    error_message = "The landing-zone EKS module must expose the cluster endpoint."
  }
}
