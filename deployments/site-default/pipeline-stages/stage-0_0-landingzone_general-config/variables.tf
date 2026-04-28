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

variable "platform_name" {
  description = <<-EOT
  Canonical platform identifier used in tags, names, and higher-level naming
  conventions.

  Example:
  - platform
  EOT
  type        = string
}

variable "environment" {
  description = <<-EOT
  Logical environment designation for the landing zone.

  Example:
  - dev
  - preprod
  - prod
  EOT
  type        = string
}

variable "aws_region" {
  description = <<-EOT
  AWS region in which the landing-zone stages are deployed.

  Example:
  - us-west-2
  EOT
  type        = string
}

variable "aws_profile" {
  description = <<-EOT
  Shared AWS CLI or SDK profile used by local execution workflows.

  Example:
  - engineering-dev
  EOT
  type        = string
}

variable "company_name" {
  description = <<-EOT
  Organization or business identifier used in naming, tags, and ownership
  metadata.
  EOT
  type        = string
}

variable "cluster_name" {
  description = <<-EOT
  Canonical Amazon EKS cluster name derived from platform naming rules.
  EOT
  type        = string
}

variable "hosted_zone_name" {
  description = <<-EOT
  Private DNS zone name attached to the landing-zone VPC for platform and
  workload service discovery.
  EOT
  type        = string
}

variable "vpc_cidr" {
  description = <<-EOT
  Primary CIDR block for the landing-zone VPC.
  EOT
  type        = string
}

variable "availability_zones" {
  description = <<-EOT
  Ordered list of availability zones used by the VPC and subnet layout.
  EOT
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = <<-EOT
  Private subnet CIDRs aligned one-to-one with availability_zones.
  EOT
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = <<-EOT
  Public subnet CIDRs aligned one-to-one with availability_zones.
  EOT
  type        = list(string)
}

variable "cluster_version" {
  description = <<-EOT
  Target Kubernetes version for the Amazon EKS control plane.

  Example:
  - 1.33
  EOT
  type        = string
}

variable "backend" {
  description = <<-EOT
  StagePlane backend orchestration contract. In managed mode, this stage creates
  the backend substrate for subsequent stages. In external mode, the controller
  renders the user-provided backend without creating state infrastructure.
  EOT
  type        = any
}

variable "compute" {
  description = <<-EOT
  Unified StagePlane compute contract. This required object is the sole source
  for EKS managed node groups, Fargate profiles, and optional Karpenter node
  supported in the pre-GA baseline.
  EOT
  type        = any
}

variable "argocd_enabled" {
  description = "Enables Argo CD installation for this site."
  type        = bool
}

variable "argocd_namespace" {
  description = "Namespace used by the Argo CD control plane."
  type        = string
}

variable "argocd_chart_version" {
  description = "Pinned Argo CD Helm chart version used by the Argo CD stage."
  type        = string
}

variable "argocd_bootstrap_enabled" {
  description = "Enables post-install GitOps bootstrap and optional admin password rotation."
  type        = bool
}

variable "argocd_base_kustomize" {
  description = "Optional local or remote kustomize source applied as the Argo CD base activation layer by stagectl."
  type        = string
}

variable "argocd_bootstrap_kustomize" {
  description = "Optional local or remote kustomize source applied after Argo CD becomes reachable."
  type        = string
}

variable "argocd_admin_password" {
  description = "Optional stable admin password set during bootstrap. Prefer sourcing this from an encrypted site settings workflow."
  type        = string
}
