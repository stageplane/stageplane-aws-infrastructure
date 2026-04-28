<!-- -----------------------------------------------------------------------------
Copyright
------------------------------------------------------------------------------
Copyright (c) 2026 Vladimir Fonseca. All rights reserved.
-->

# AWS module - self-managed Karpenter

## Purpose

Installs and configures self-managed Karpenter as an optional capacity layer for the EKS cluster.

## Responsibility boundary

This module owns:
- the Karpenter namespace
- the pinned Karpenter Helm release
- cluster identity values needed by the controller chart

This module does not own:
- the baseline EKS cluster
- managed node groups used for cluster bootstrap
- higher-level site policy on whether Karpenter should be enabled at all
