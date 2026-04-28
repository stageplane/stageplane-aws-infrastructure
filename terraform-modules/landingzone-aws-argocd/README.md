<!-- -----------------------------------------------------------------------------
Copyright
------------------------------------------------------------------------------
Copyright (c) 2026 Vladimir Fonseca. All rights reserved.
-->


# Landing zone - AWS Argo CD

## Purpose

Installs Argo CD as the GitOps control-plane foundation for the target EKS site.

## Responsibility boundary

This module owns only the in-cluster Argo CD installation. Runtime bootstrap operations stay in `stagectl/gitops` so password rotation and site-specific GitOps source activation remain out of Terraform state.
