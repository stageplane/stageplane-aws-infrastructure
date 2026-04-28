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

# -----------------------------------------------------------------------------
# Intent
# -----------------------------------------------------------------------------
# This stage normalizes the shared landing-zone settings that originate from the
# YAML-driven configuration model. The generated tfvars artifact is applied only
# to this stage; downstream stages consume the resulting canonical settings
# object through Terraform remote state.
#
# Design note:
# - Optional Karpenter settings are normalized here too so later stages can
#   enable or disable elastic capacity from the same site-scoped YAML contract.
# -----------------------------------------------------------------------------

locals {
  normalized_settings = {
    platform_name              = var.platform_name
    environment                = var.environment
    aws_region                 = var.aws_region
    aws_profile                = var.aws_profile
    company_name               = var.company_name
    cluster_name               = var.cluster_name
    hosted_zone_name           = var.hosted_zone_name
    vpc_cidr                   = var.vpc_cidr
    availability_zones         = var.availability_zones
    private_subnet_cidrs       = var.private_subnet_cidrs
    public_subnet_cidrs        = var.public_subnet_cidrs
    cluster_version            = var.cluster_version
    backend                    = var.backend
    compute                    = var.compute
    argocd_enabled             = var.argocd_enabled
    argocd_namespace           = var.argocd_namespace
    argocd_chart_version       = var.argocd_chart_version
    argocd_bootstrap_enabled   = var.argocd_bootstrap_enabled
    argocd_base_kustomize      = var.argocd_base_kustomize
    argocd_bootstrap_kustomize = var.argocd_bootstrap_kustomize
    argocd_admin_password      = var.argocd_admin_password
  }
}

data "terraform_remote_state" "none" {
  count   = 0
  backend = "local"
  config  = {}
}

module "landingzone_global_settings" {
  source = "../../../../terraform-modules/landingzone-global-settings"

  settings = local.normalized_settings
}
