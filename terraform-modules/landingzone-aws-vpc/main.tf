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
    PlatformLayer = "network"
    Owner         = "platform"
  }

  vpc_name = format("%s-%s-%s-vpc", var.settings.company_name, var.settings.environment, var.settings.aws_region)
}

data "aws_region" "current" {}

module "aws_vpc" {
  source = "../aws-modules/aws-vpc"

  name                 = local.vpc_name
  cidr                 = var.settings.vpc_cidr
  azs                  = var.settings.availability_zones
  private_subnets      = var.settings.private_subnet_cidrs
  public_subnets       = var.settings.public_subnet_cidrs
  enable_dns_hostnames = true
  enable_dns_support   = true
  common_tags          = local.common_tags
}
