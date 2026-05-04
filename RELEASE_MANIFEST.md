<!-- -----------------------------------------------------------------------------
Copyright
------------------------------------------------------------------------------
Copyright (c) 2026 Vladimir Fonseca. All rights reserved.
-->

# StagePlane AWS Infrastructure Release Manifest — 20260502053000

## Artifact

- Package: `stageplane-aws-infrastructure-20260502060000.zip`
- Component: StagePlane public AWS infrastructure baseline
- Baseline source: user-provided `stageplane-aws-infrastructure.zip`

## Release intent

This release updates the public AWS baseline for the StagePlane `managed-state-rbac` Pro / Team feature. It adds site-local stage access policy wiring, a shared stage-access profile, operator Makefile targets, public operation workflow entries, and documentation.

## Delta summary

- Added `deployments/site-default/config/stage_access.yaml`.
- Added `access-policies/stage-access/prod-default.yaml`.
- Added `docs/21-stage-access-rbac.md`.
- Updated `README.md` to describe managed-state RBAC and the new operator commands.
- Updated `Makefile` with:
  - `managed-state-preflight`
  - `stage-access-describe`
  - `stage-access-render-policy`
- Updated `.github/workflows/public-operations.yaml` with manual operations for the same stage-access commands.
- Preserved existing AWS/EKS stages, Terraform modules, GitHub workflows, SOPS model, and StagePlane public baseline layout.

## Validation

Run before promotion:

```bash
unzip -t stageplane-aws-infrastructure-20260502060000.zip
make check-stagectl STAGECTL=./bin/stagectl
make describe-site SITE_NAME=site-default STAGECTL=./bin/stagectl STAGECTL_VERBOSITY=json
```

With a Pro license, validate the managed-state RBAC example:

```bash
export STAGECTL_LICENSE_FILE=/path/to/stageplane-pro.license
make managed-state-preflight SITE_NAME=site-default STAGECTL=./bin/stagectl STAGECTL_VERBOSITY=json
make stage-access-describe SITE_NAME=site-default STAGECTL=./bin/stagectl STAGECTL_VERBOSITY=json
make stage-access-render-policy SITE_NAME=site-default STAGE_ACCESS_STAGE=compute STAGE_ACCESS_ACCOUNT_ID=123456789012 STAGECTL=./bin/stagectl STAGECTL_VERBOSITY=json
```

## Security posture

The added `stage_access.yaml` and shared profile contain placeholder AWS role ARNs only. They do not contain cloud credentials, external IDs, access keys, secrets, or production account information. Operators must replace placeholder ARNs before production use.


## 20260502060000 hardening delta

- Added README warnings for GPU Spot fallback cost risk and sample Kubernetes/EKS version availability.
- Updated packaged `bin/stagectl` to the 20260502060000 hardening binary.
- Preserved StagePlane managed-state RBAC examples and binary provenance files.

## 20260502064500 — stagectl release distribution update

- Replaced the committed architecture-specific `bin/stagectl` binary with an architecture-neutral shim.
- Added public `stageplane/stagectl-releases` installer consumption for macOS/Linux/Windows and amd64/arm64 binaries.
- Updated public CI and operations workflows to use the installer/shim model with `STAGECTL_VERSION`.
- Updated `public-operations.yaml` to use GitHub OIDC with `AWS_ROLE_TO_ASSUME` instead of long-lived AWS access keys.
- Added `docs/22-stagectl-release-distribution.md` documenting the installer, shim, manifest, and OIDC model.

## 20260503010000 — AWS shim installer cleanup hardening

- Hardened the repository-local `bin/stagectl` shim so the public AWS baseline no longer depends on a curl-piped installer cleanup path during CI bootstrap.
- Preserved architecture-neutral stagectl release consumption while adding local OS/architecture asset download, checksum verification, cache reuse, and safe temporary-directory cleanup directly in the shim.
- Preserved restored GitHub Actions workflows and release artifacts from the 20260502060000 baseline.
- Kept GitHub Actions away from deprecated Node.js 20 action runtimes.

## 20260503024500 — OIDC, EKS endpoint, and Karpenter IRSA hardening

- Updated `public-operations.yaml` to use GitHub OIDC with `AWS_ROLE_TO_ASSUME` and `id-token: write`, removing the static `AWS_ACCESS_KEY_ID` / `AWS_SECRET_ACCESS_KEY` credential path.
- Added `cluster_endpoint_public_access_cidrs` to the site settings contract and EKS Terraform module flow so the public API endpoint no longer relies on the upstream open-to-world default.
- Added optional Karpenter controller IRSA role annotation wiring through `compute.karpenter.irsa_role_arn`.
- Regenerated `deployments/site-default/config/generated/general_settings.runtime.tfvars.json` to preserve the full settings contract with the new endpoint CIDR and Karpenter IRSA fields.
- Preserved restored workflows, architecture-neutral stagectl shim distribution, and Node.js 20-free GitHub Actions posture.
