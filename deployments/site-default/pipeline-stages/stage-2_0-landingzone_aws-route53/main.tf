# -----------------------------------------------------------------------------
# Copyright
# -----------------------------------------------------------------------------
# Copyright (c) 2026 Vladimir Fonseca. All rights reserved.
#

# -----------------------------------------------------------------------------
# File intent
# -----------------------------------------------------------------------------
# This file holds the implementation flow for the module. Per repository rule,
# blocks are ordered as locals, then data, then resources, and child modules at
# the end. If the module becomes too large, complexity must move into child
# modules instead of additional sibling Terraform files.
# -----------------------------------------------------------------------------


locals {
  stage_name = "landingzone-aws-route53"
}

data "terraform_remote_state" "general" {
  backend = "local"
  config = {
    path = "../stage-0_0-landingzone_general-config/terraform.tfstate"
  }
}

data "terraform_remote_state" "vpc" {
  backend = "local"
  config = {
    path = "../stage-1_0-landingzone_aws-vpc/terraform.tfstate"
  }
}

# -----------------------------------------------------------------------------
# Intent
# -----------------------------------------------------------------------------
# Stage 2 binds a private DNS zone to the landing-zone VPC so internal platform
# and workload records have a stable namespace before cluster services arrive.
# -----------------------------------------------------------------------------
module "landingzone_aws_route53" {
  source = "../../../../terraform-modules/landingzone-aws-route53"

  settings = data.terraform_remote_state.general.outputs.settings
  vpc_id   = data.terraform_remote_state.vpc.outputs.vpc_id
}
