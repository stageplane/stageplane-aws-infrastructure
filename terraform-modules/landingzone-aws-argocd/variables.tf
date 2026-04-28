# -----------------------------------------------------------------------------
# Copyright
# -----------------------------------------------------------------------------
# Copyright (c) 2026 Vladimir Fonseca. All rights reserved.
#

# -----------------------------------------------------------------------------
# File intent
# -----------------------------------------------------------------------------
# This file defines the input contract for the module. Variables must describe
# intent, ownership scope, notable constraints, and example cases where helpful.
# -----------------------------------------------------------------------------

variable "settings" {
  description = "Canonical site settings rendered from general_settings.yaml."
  type = object({
    platform_name                   = string
    environment                     = string
    aws_region                      = string
    aws_profile                     = string
    company_name                    = string
    cluster_name                    = string
    hosted_zone_name                = string
    vpc_cidr                        = string
    availability_zones              = list(string)
    private_subnet_cidrs            = list(string)
    public_subnet_cidrs             = list(string)
    cluster_version                 = string
    argocd_enabled                  = bool
    argocd_namespace                = string
    argocd_chart_version            = string
    argocd_bootstrap_enabled        = bool
    argocd_base_kustomize           = string
    argocd_bootstrap_kustomize      = string
    argocd_admin_password           = string
    argocd_admin_password_sops_file = optional(string)
  })
}

variable "cluster_name" {
  description = "Cluster name retained for wrapper compatibility."
  type        = string
}

variable "cluster_endpoint" {
  description = "Cluster endpoint retained for wrapper compatibility."
  type        = string
}
