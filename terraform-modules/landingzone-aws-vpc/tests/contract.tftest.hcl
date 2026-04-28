# -----------------------------------------------------------------------------
# Copyright
# -----------------------------------------------------------------------------
# Copyright (c) 2026 Vladimir Fonseca. All rights reserved.
#

# -----------------------------------------------------------------------------
# Intent
# -----------------------------------------------------------------------------
# Verifies the landing-zone VPC wrapper contract while configuring and mocking
# the AWS provider, then overriding the child module outputs. This ensures the
# wrapper naming and output flow remain stable without live AWS API calls.
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


override_module {
  target = module.aws_vpc

  outputs = {
    vpc_id             = "vpc-landingzone-1234"
    private_subnet_ids = ["subnet-private-a", "subnet-private-b"]
    public_subnet_ids  = ["subnet-public-a", "subnet-public-b"]
  }
}

run "exports_landingzone_vpc_outputs" {
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
      argocd_bootstrap_enabled   = false
      argocd_base_kustomize      = ""
      argocd_bootstrap_kustomize = ""
      argocd_admin_password      = ""
    }
  }

  assert {
    condition     = output.vpc_id == "vpc-landingzone-1234"
    error_message = "The landing-zone VPC module must expose the child VPC identifier."
  }

  assert {
    condition     = length(output.private_subnet_ids) == 2
    error_message = "The landing-zone VPC module must expose private subnets."
  }

  assert {
    condition     = length(output.public_subnet_ids) == 2
    error_message = "The landing-zone VPC module must expose public subnets."
  }
}
