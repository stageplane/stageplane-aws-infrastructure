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
  stage_name = "landingzone-aws-vpc"
}

data "terraform_remote_state" "general" {
  backend = "local"
  config = {
    path = "../stage-0_0-landingzone_general-config/terraform.tfstate"
  }
}

# -----------------------------------------------------------------------------
# Intent
# -----------------------------------------------------------------------------
# Stage 1 turns the normalized platform settings into the foundational network
# substrate used by all later AWS components.
# -----------------------------------------------------------------------------
module "landingzone_aws_vpc" {
  source = "../../../../terraform-modules/landingzone-aws-vpc"

  settings = data.terraform_remote_state.general.outputs.settings
}
