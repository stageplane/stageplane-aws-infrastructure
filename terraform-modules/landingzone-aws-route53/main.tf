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
  common_tags = {
    Environment   = var.settings.environment
    ManagedBy     = "Terraform"
    PlatformLayer = "dns"
    Owner         = "platform"
  }
}

data "aws_region" "current" {}

data "aws_partition" "current" {}

module "aws_route53" {
  source = "../aws-modules/aws-route53"

  zone_name   = var.settings.hosted_zone_name
  vpc_id      = var.vpc_id
  common_tags = local.common_tags
}
