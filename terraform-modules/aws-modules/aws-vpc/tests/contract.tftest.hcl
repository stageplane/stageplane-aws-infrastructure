# -----------------------------------------------------------------------------
# Copyright
# -----------------------------------------------------------------------------
# Contains or integrates third-party material. Upstream ownership and license
# remain with the original owner.
#

# -----------------------------------------------------------------------------
# Intent
# -----------------------------------------------------------------------------
# Verifies the repository wrapper around the upstream VPC module by overriding
# the child module outputs. The AWS provider is explicitly configured and then
# mocked so Terraform never attempts live cloud authentication during contract
# validation.
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
  target = module.upstream_vpc

  outputs = {
    vpc_id          = "vpc-1234567890"
    private_subnets = ["subnet-private-a", "subnet-private-b"]
    public_subnets  = ["subnet-public-a", "subnet-public-b"]
  }
}

run "exports_upstream_vpc_contract" {
  command = plan

  variables {
    name                 = "example-dev-us-west-2-vpc"
    cidr                 = "10.0.0.0/16"
    azs                  = ["us-west-2a", "us-west-2b"]
    private_subnets      = ["10.0.0.0/20", "10.0.16.0/20"]
    public_subnets       = ["10.0.128.0/24", "10.0.129.0/24"]
    enable_dns_hostnames = true
    enable_dns_support   = true
    common_tags = {
      Environment = "dev"
      ManagedBy   = "Terraform"
    }
  }

  assert {
    condition     = output.vpc_id == "vpc-1234567890"
    error_message = "The VPC wrapper must preserve the upstream VPC identifier."
  }

  assert {
    condition     = length(output.private_subnet_ids) == 2
    error_message = "The VPC wrapper must preserve private subnet identifiers."
  }

  assert {
    condition     = length(output.public_subnet_ids) == 2
    error_message = "The VPC wrapper must preserve public subnet identifiers."
  }
}
