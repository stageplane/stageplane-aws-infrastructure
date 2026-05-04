# StagePlane Release — 20260428211650

## Summary

This release keeps the validated StagePlane technical baseline intact and adds the external-facing documentation surface needed for early customer evaluation.

StagePlane is a staged Terraform and OpenTofu orchestrator with a human-first YAML configuration model and a portable CLI (`stagectl`). The AWS baseline remains the first reference implementation, not the definition of the platform.

## Highlights

### Backend lifecycle

- Managed backend mode remains the default.
- `stage-0_0` bootstraps backend state infrastructure for the AWS baseline.
- External backend mode remains available for teams that already manage Terraform/OpenTofu state.

### Structured logging

- Settings-layer compute scaling uses the controller logging path.
- No internal compute-stage debug output is emitted with raw `fmt.Printf`.

### Unified compute model

- `compute.node_groups` remains the authoritative compute contract.
- On-demand, spot, mixed, Fargate, and optional Karpenter capacity patterns remain supported.
- Minimum compute validation is enforced by the controller.

### Governance and packaging

- Public and controller packages remain separate.
- The public package continues to carry the bundled `bin/stagectl` binary for operator and CI convenience.
- Documentation entry points are included for quickstart, release notes, and customer-facing overview.

## Artifacts

- `stageplane-aws-infrastructure-20260428211650.zip`
- `stageplane-controller-20260428211650.zip`
- `stageplane-docs-site-20260428211650.zip`

## Status

Ready for early customer and internal platform-team evaluation.

## 20260502053000 — Managed-state RBAC public baseline update

This release adds public AWS baseline support for the StagePlane `managed-state-rbac` Pro / Team feature.

Added:

- `deployments/site-default/config/stage_access.yaml` for site-local stage access policy selection.
- `access-policies/stage-access/prod-default.yaml` as a reusable shared stage-access profile.
- `docs/21-stage-access-rbac.md` with the YAML contract, operator commands, and security boundaries.
- Makefile targets for `managed-state-preflight`, `stage-access-describe`, and `stage-access-render-policy`.
- Public GitHub Actions operation entries for the same stage-access commands.

The example uses placeholder AWS role ARNs and state bucket names. It is intended to demonstrate the StagePlane access model and must be customized before production use.

## 20260502060000 — Pre-release hardening notes

- Documented GPU Spot fallback cost risk in the public README.
- Documented that sample Kubernetes/EKS versions must be verified in the target AWS region before live deployment.
- Preserved managed-state RBAC examples and public `stagectl` binary consumption flow.

## 20260502064500 — stagectl release distribution update

- Replaced the committed architecture-specific `bin/stagectl` binary with an architecture-neutral shim.
- Added public `stageplane/stagectl-releases` installer consumption for macOS/Linux/Windows and amd64/arm64 binaries.
- Updated public CI and operations workflows to use the installer/shim model with `STAGECTL_VERSION`.
- Updated `public-operations.yaml` to use GitHub OIDC with `AWS_ROLE_TO_ASSUME` instead of long-lived AWS access keys.
- Added `docs/22-stagectl-release-distribution.md` documenting the installer, shim, manifest, and OIDC model.

## 20260503010000 — AWS shim installer cleanup hardening

- Hardened the repository-local `bin/stagectl` shim used by the public AWS baseline.
- The shim now downloads and verifies the correct stagectl release asset directly, then delegates to the cached binary.
- This avoids CI failures caused by unsafe temporary-directory cleanup in an external installer path while preserving architecture-neutral release distribution.
- Restored GitHub Actions and release placeholder artifacts remain present.
- GitHub Actions remain updated away from deprecated Node.js 20 action runtimes.

## 20260503024500 — OIDC, EKS endpoint, and Karpenter IRSA hardening

- `public-operations.yaml` now matches the documented OIDC posture by assuming `AWS_ROLE_TO_ASSUME` instead of consuming long-lived AWS access keys.
- The EKS cluster module now exposes `cluster_endpoint_public_access_cidrs` so public endpoint access is explicitly restricted by site configuration.
- Karpenter now supports an optional `compute.karpenter.irsa_role_arn` setting that annotates the controller service account for runtime node provisioning.
- Generated runtime tfvars were refreshed from the YAML settings contract.

## 20260503025500 — Terraform/OpenTofu formatting correction

- Corrects Terraform formatting in the EKS module call sites introduced by the endpoint CIDR hardening update.
- Preserves the 20260503024500 OIDC, EKS endpoint CIDR, Karpenter IRSA, generated runtime tfvars, and Node.js 20-free workflow posture.

