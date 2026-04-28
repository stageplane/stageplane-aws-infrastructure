# -----------------------------------------------------------------------------
# Copyright
# -----------------------------------------------------------------------------
# Copyright (c) 2026 Vladimir Fonseca. All rights reserved.
#

# -----------------------------------------------------------------------------
# Intent
# -----------------------------------------------------------------------------
# Verifies the landing-zone add-ons composition contract by overriding the
# child module outputs while mocking AWS-backed data sources.
# -----------------------------------------------------------------------------

mock_provider "aws" {}

override_module {
  target = module.aws_eks_cluster_addons

  outputs = {
    enabled_addons = [
      "aws-ebs-csi-driver",
      "metrics-server",
      "aws-load-balancer-controller",
    ]
  }
}

run "exports_landingzone_addons_contract" {
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
    cluster_name     = "example-dev-us-west-2-eks"
    cluster_endpoint = "https://example.eks.amazonaws.com"
  }

  assert {
    condition     = length(output.enabled_addons) == 3
    error_message = "The landing-zone add-ons module must preserve the expected baseline add-on set."
  }
}
