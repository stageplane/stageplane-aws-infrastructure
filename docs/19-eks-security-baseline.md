<!-- -----------------------------------------------------------------------------
Copyright
------------------------------------------------------------------------------
Copyright (c) 2026 Vladimir Fonseca. All rights reserved.
-->

# EKS Security Baseline Guidance

This document summarizes the recommended security posture when using the StagePlane AWS baseline in production.

## Core principles

- prefer explicit IAM role ownership over broad shared credentials
- keep cluster administration separate from node and workload permissions
- use KMS-backed encryption for state, secrets, and storage where applicable
- minimize long-lived credentials in CI and operator environments
- keep Argo CD and add-on bootstrap ownership explicit

## Identity and access

Recommended posture:

- prefer **EKS Pod Identity** where available for add-ons and workloads that need AWS access
- use **IRSA/OIDC-backed service account roles** where Pod Identity is not yet appropriate or where existing integrations depend on it
- keep node instance roles minimal and avoid treating nodes as the default identity boundary for workloads
- define break-glass administrator access separately from normal operator access

## Cluster and node guidance

- pin and review the Kubernetes version intentionally
- review managed node group instance roles and attached policies for least privilege
- document which add-ons receive AWS permissions and why
- avoid broad wildcard policies for controllers, GitOps, observability, or autoscaling components

## Secrets and keys

- keep site secrets encrypted with SOPS
- use customer-owned KMS keys where required by policy
- do not place plaintext secrets in `general_settings.yaml`
- review Argo CD bootstrap password handling and secret rotation practices before production

## State and backend security

- encrypt the state bucket with KMS
- enable versioning and access logging on the state bucket
- restrict DynamoDB lock table access to the specific operator/CI principals that need it
- treat generated runtime files as operationally sensitive artifacts

## Network and GitOps posture

- review public vs private endpoint settings intentionally
- document Route53 zone ownership and change authority
- decide whether GitOps is local/self-hosted or central/shared before bootstrap
- keep central/shared GitOps onboarding behind an explicit ownership and approval model

## Compute and capacity security posture

The AWS reference baseline uses `compute.node_groups` as the single worker-capacity contract. This avoids ambiguous precedence between legacy flat node variables, managed node groups, Fargate profiles, and Karpenter pools.

Recommended posture:

- Keep a small on-demand system node group for deterministic bootstrap and platform add-ons.
- Use Fargate only for namespace-scoped pod placement where the workload does not require EC2 node-level controls, GPUs, host networking, or daemonset behavior.
- Use spot only with multiple instance types so interruption and capacity-market behavior do not collapse into a single SKU dependency.
- Treat Karpenter as an optional elastic capacity plane. It should complement baseline node groups rather than replace the deterministic bootstrap foundation.
- Do not model unsupported EC2 Spot controls as if they were guaranteed by EKS managed node groups. Price-aware or market-aware behavior must be routed through an execution path that can actually enforce it.
