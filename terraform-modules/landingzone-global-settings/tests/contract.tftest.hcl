# -----------------------------------------------------------------------------
# Copyright
# -----------------------------------------------------------------------------
# Copyright (c) 2026 Vladimir Fonseca. All rights reserved.
#

# -----------------------------------------------------------------------------
# Intent
# -----------------------------------------------------------------------------
# Verifies the canonical settings contract exported by the global settings
# module without requiring any live cloud interaction.
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

run "exports_settings_contract" {
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
  }

  assert {
    condition     = output.settings.environment == "dev"
    error_message = "The global settings module must preserve the environment field."
  }

  assert {
    condition     = output.settings.compute.karpenter.enabled == false
    error_message = "The global settings module must preserve optional Karpenter flags."
  }

  assert {
    condition     = output.settings.argocd_bootstrap_enabled == true
    error_message = "The global settings module must preserve optional Argo CD bootstrap flags."
  }
}
