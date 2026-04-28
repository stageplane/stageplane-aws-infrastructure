# StagePlane — Control Plane for Terraform and OpenTofu

StagePlane is a staged Terraform and OpenTofu orchestrator for platform teams that want deterministic, repo-centric infrastructure operations without a mandatory SaaS control plane.

## What StagePlane provides

- Explicit staged execution.
- Human-first YAML configuration.
- A portable operator CLI (`stagectl`).
- Terraform and OpenTofu runtime support.
- Managed or external backend lifecycle.
- Unified compute modeling for on-demand, spot, mixed, Fargate, and Karpenter capacity.
- Structured logging for operator and automation workflows.

## Why teams use StagePlane

| Challenge | StagePlane approach |
| --- | --- |
| Terraform execution is ad hoc | Staged execution with deterministic ordering |
| Configuration is fragmented | Human-readable YAML rendered by the controller |
| State bootstrap is manual | Managed backend lifecycle with external backend escape hatch |
| Compute is hard to standardize | Unified node group and elastic capacity model |
| Debugging automation is noisy | Structured logging across controller workflows |

## What StagePlane is not

- Not a Terraform replacement.
- Not a SaaS platform.
- Not an EKS-only product.

The AWS baseline is the first reference implementation. StagePlane itself is the orchestration layer.
