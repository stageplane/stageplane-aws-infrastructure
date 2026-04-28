# -----------------------------------------------------------------------------
# Copyright
# -----------------------------------------------------------------------------
# Copyright (c) 2026 Vladimir Fonseca. All rights reserved.
#


# -----------------------------------------------------------------------------
# File intent
# -----------------------------------------------------------------------------
# Installs Argo CD into the EKS cluster by composing the lower-level aws-modules
# wrapper with a normalized settings contract exported from stage 0.
# -----------------------------------------------------------------------------

locals {
  common_tags = {
    Environment   = var.settings.environment
    ManagedBy     = "Terraform"
    PlatformLayer = "gitops"
    Owner         = "platform"
  }
}

data "aws_eks_cluster" "target" {
  name = var.cluster_name
}

data "aws_eks_cluster_auth" "target" {
  name = var.cluster_name
}

module "aws_argocd" {
  source = "../aws-modules/aws-argocd"

  namespace     = var.settings.argocd_namespace
  chart_version = var.settings.argocd_chart_version

  cluster_name = var.cluster_name
}
