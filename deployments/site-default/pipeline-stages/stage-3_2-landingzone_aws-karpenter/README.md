<!-- -----------------------------------------------------------------------------
Copyright
------------------------------------------------------------------------------
Copyright (c) 2026 Vladimir Fonseca. All rights reserved.
-->

# Stage 3.2 - landingzone-aws-karpenter

## Purpose

This stage optionally installs **self-managed Karpenter** after the baseline EKS cluster and core add-ons exist.
It gives a site an elastic capacity layer without replacing the managed node groups used for cluster bootstrap.

## Responsibility boundary

This stage owns:
- optional Karpenter controller deployment
- Karpenter namespace and release configuration
- propagation of site-scoped Karpenter settings from stage 0 normalized configuration

This stage does not own:
- baseline VPC creation
- EKS cluster creation
- baseline add-ons required before Karpenter can be layered on
- workload-specific NodePool policy beyond the module defaults

## Input model

This stage reads:
- canonical site settings from `stage-0_0-landingzone_general-config`
- EKS cluster outputs from `stage-3_0-landingzone_aws-eks-cluster`

The operator does not pass a separate var-file directly to this stage.
Karpenter enablement and chart settings must come from the site YAML rendered and normalized by stage 0.

## Example cases

