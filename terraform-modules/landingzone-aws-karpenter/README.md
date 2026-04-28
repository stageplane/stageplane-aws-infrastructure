<!-- -----------------------------------------------------------------------------
Copyright
------------------------------------------------------------------------------
Copyright (c) 2026 Vladimir Fonseca. All rights reserved.
-->

# Landing zone module - AWS Karpenter

## Purpose

This module is the landing-zone composition point for **optional self-managed Karpenter**.
It translates site policy from normalized stage 0 settings into a reusable controller-install action.

## Responsibility boundary

This module owns:
- the site-level decision to enable or disable self-managed Karpenter
- propagation of the normalized Karpenter namespace and chart version settings
- composition of the lower-level `aws-karpenter` module

This module does not own:
- EKS cluster creation
- baseline managed node groups
- VPC or Route53 foundations
