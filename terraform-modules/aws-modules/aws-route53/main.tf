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
  normalized_zone_name = trimsuffix(var.zone_name, ".")
}

data "aws_region" "current" {}

# -----------------------------------------------------------------------------
# Intent
# -----------------------------------------------------------------------------
# Creates a private hosted zone anchored to the landing-zone VPC so workloads
# can publish internal service records without exposing them publicly.
# -----------------------------------------------------------------------------
resource "aws_route53_zone" "private" {
  name = local.normalized_zone_name

  vpc {
    vpc_id = var.vpc_id
  }

  tags = var.common_tags
}
