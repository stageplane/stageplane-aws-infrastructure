<!-- -----------------------------------------------------------------------------
Copyright
------------------------------------------------------------------------------
Copyright (c) 2026 Vladimir Fonseca. All rights reserved.
-->


# Stage 4 - Argo CD root

## Purpose

Activates the GitOps control plane after the EKS substrate and baseline add-ons exist.

## Responsibility boundary

This stage owns Argo CD installation only. Runtime bootstrap actions such as initial login, admin password rotation, and optional GitOps base/application apply are owned by `stagectl`, not Terraform.

## File contract

This module follows the repository standard:
- `README.md`
- `main.tf`
- `variables.tf`
- `output.tf`
- `version.tf`
